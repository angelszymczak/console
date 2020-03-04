module Console
  module Commands
    class Whoami < Session
      ARGS_COUNT = 0
      OPTIONS_COUNT = 0

      def perform
        Console::User.current_user.username
      end

      register(:whoami, self)
    end
  end
end
