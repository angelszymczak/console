module Console
  module Commands
    class MalFormed < StandardError
      def valid?
        false
      end
    end
  end
end
