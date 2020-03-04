module Console
  class File
    class Metadata < Base
      DEFAULT_TYPE = 'plain'
      MAX_TYPE_SIZE = 10 # 1MB

      attr_accessor :author, :type, :timestamp

      def initialize(author, type, timestamp = nil)
        super()

        self.author = author
        self.type = type || DEFAULT_TYPE
        self.timestamp = timestamp || Time.now.to_i
      end

      def to_s
        "Author: [#{author}] - Date: #{Time.at(timestamp).strftime('%d-%m-%Y')} - #{type}."
      end

      def valid?
        valid_metadata_type?
      end

      def valid_metadata_type?
        return true if type.length <= MAX_TYPE_SIZE

        @errors[:type] = Error.new(
          "Type [#{type.slice(0..10)}] exceed limit size [#{MAX_TYPE_SIZE}]."
        )
        false
      end
    end
  end
end
