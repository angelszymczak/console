module Console
  module Commands
    class Ls < Folder
      ARGS_COUNT = 1
      OPTIONS_COUNT = 0

      def perform
        unless (list = Console::Folder.ls(@directory, @target)).nil?
          "#{list.join(' ')}"
        else
          "Invalid [#{arguments.join}] path."
        end
      end

      def allow?
        true
      end

      def arguments_condition
        arguments.count <= ARGS_COUNT
      end

      register(:ls, self)
    end
  end
end
