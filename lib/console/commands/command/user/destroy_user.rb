module Console
  module Commands
    class DestroyUser < User
      ARGS_COUNT = 1
      OPTIONS_COUNT= 0

      def perform
        if (user = Console::User.find_by(arguments.join)).nil?
          "Can\'t destroy [#{arguments.join}]."
        elsif (Console::User.current_user == user)
           "Can\'t destroy current logged user."
        else
          Console::User.destroy(user)
          "User [#{user.username}] was destroyed."
        end
      end

      def valid_options?
        valid_options_count?
      end

      private

      def valid_options_count?
        return true if options.keys.count == OPTIONS_COUNT

        @errors[:options] = MalFormed.new(
          "Expected [#{OPTIONS_COUNT}] options. You've sent #{options.count}: #{options}."
        )
        false
      end

      register(:destroy_user, self)
    end
  end
end
