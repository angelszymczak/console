module Console
  module Commands
    class Logout < Session
      ARGS_COUNT = 0

      def perform
        puts "Ok, ok, I'm out. Bye #{Console::User.current_user.username} :("
        exit_session
      end

      register(:logout, self)
    end
  end
end
