module Console
  module Commands
    class Metadata < File
      ARGS_COUNT = 1
      OPTIONS_COUNT = 0

      def perform
        unless (metadata = Console::Folder.metadata(@directory, @target)).nil?
          metadata.to_s
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

      register(:metadata, self)
    end
  end
end
