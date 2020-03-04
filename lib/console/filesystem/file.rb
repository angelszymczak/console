module Console
  class File < Filesystem
    MAX_CONTENT_SIZE = 1_000_000 # 1MB

    def self.create(directory, name, content, type)
      new(name, content, type).tap do |folder|
        store.storing { directory.add(folder) } if folder.valid?
      end
    end

    attr_accessor :content, :metadata

    def initialize(name, content = nil, type = nil)
      super(name)

      self.content = content
      self.metadata = Metadata.new(User.current_user, type)
    end

    def file?
      true
    end

    def valid?
      super() && valid_content_size? && metadata_valid?
    end

    def valid_content_size?
      return true if content.bytesize <= MAX_CONTENT_SIZE

      @errors[:content] = Error.new(
        "Content [#{content.slice(0..30)}...]\
        exceed limit size [#{MAX_CONTENT_SIZE}] by [#{content.size}]."
      )
      false
    end

    def metadata_valid?
      return true if metadata.valid?

      @errors[:metadata] = metadata.error_message
      false
    end
  end
end
