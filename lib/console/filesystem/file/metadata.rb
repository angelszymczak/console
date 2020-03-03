module Console
  class File
    class Metadata
      attr_accessor :author, :timestamp

      def initialize(author, timestamp = nil)
        self.author = author
        self.timestamp = timestamp || Time.now.to_i
      end

      def to_s
        "Author: [#{author}] - Date: #{Time.at(timestamp).strftime('%d-%m-%Y')}"
      end
    end
  end
end
