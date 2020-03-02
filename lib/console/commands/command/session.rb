module Console
  module Commands
    class Session < Command
      OPTIONS = {}

      def allow?
        true
      end

      def valid_options?
        true
      end
    end
  end
end
