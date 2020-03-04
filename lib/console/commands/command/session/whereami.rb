module Console
  module Commands
    class Whereami < Session
      ARGS_COUNT = 0
      OPTIONS_COUNT = 0

      def perform
        Console::Filesystem.pwd.path
      end

      register(:whereami, self)
    end
  end
end
