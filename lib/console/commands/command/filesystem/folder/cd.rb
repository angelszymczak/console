module Console
  module Commands
    class Cd < Folder
      ARGS_COUNT = 1
      OPTIONS_COUNT = 0

      def perform
        unless (new_directory = Console::Folder.cd(@directory, @target)).nil?
          "#{new_directory.path}"
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

      register(:cd, self)
    end
  end
end
