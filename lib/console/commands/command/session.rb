module Console
  module Commands
    class Session < Command
      OPTIONS = {}

      def allow?
        true
      end

      def options_condition
        true
      end
    end
  end
end
