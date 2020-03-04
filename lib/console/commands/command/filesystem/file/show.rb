module Console
  module Commands
    class Show < File
      ARGS_COUNT = 1
      OPTIONS_COUNT = 0

      def perform
        unless (content = Console::Filesystem.show(@directory, @target)).nil?
          content
        else
          "No such file or directory: [#{arguments.join}]"
        end
      end

      def allow?
        true
      end

      def valid?
        super() && valid_exceptional_arguments?
      end

      register(:show, self)
    end
  end
end
