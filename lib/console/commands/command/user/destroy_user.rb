module Console
  module Commands
    class DestroyUser < User
      ARGS_COUNT = 1
      OPTIONS_COUNT= 0

      def perform
        if Console::User.logged?(username = arguments.join)
           "Can\'t destroy current logged user."
        elsif (Console::User.find_by(username)).nil?
          "Can\'t destroy [#{username}]."
        else
          Console::User.destroy(username)
          "User [#{username}] was destroyed."
        end
      end

      register(:destroy_user, self)
    end
  end
end
