module Console
  class File < Filesystem
    MAX_CONTENT_SIZE = 1_000_000 # 1MB

    attr_accessor :content, :metadata

    def initialize(name, content = nil, metadata = nil)
      super(name)

      self.content = content
      self.metadata = metadata
    end

    def file?
      true
    end

    def valid?
      super() && valid_content_size?
    end

    def valid_content_size?
      return true if content.bytesize <= MAX_CONTENT_SIZE

      @errors[:content] = Error.new(
        "Content [#{content.slice(0..30)}...]\
        exceed limit size [#{MAX_CONTENT_SIZE}] by [#{content.size}]."
      )
      false
    end
  end
end
