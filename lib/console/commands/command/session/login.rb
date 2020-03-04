module Console
  module Commands
    class Login < Session
      ARGS_COUNT = 2
      OPTIONS_COUNT = 0

      def perform
        unless (user = Console::User.login(*arguments)).nil?
          "Logged: #{user.username}."
        else
          'Invalid Credentials.'
        end
      end

      register(:login, self)
    end
  end
end
