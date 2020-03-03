module Console
  module Commands
    class UpdatePasswordUser < User
      ARGS_COUNT = 1
      OPTIONS_COUNT = 0

      def perform
        if (user = Console::User.update_password(*arguments)).valid?
          "User [#{user.username}:#{user.role}] password updated."
        else
          user.error_message
        end
      end

      def valid_options?
        valid_options_count?
      end

      def allow?
        return true if @allowance.allow? do
          Console::User.current_user.super? ||
            Console::User.current_user.regular? ||
            Console::User.current_user.read_only?
        end

        @errors[:permissions] = @allowance.message
        false
      end

      private

      def valid_options_count?
        return true if options.keys.count == OPTIONS_COUNT

        @errors[:options] = MalFormed.new(
          "Expected [#{OPTIONS_COUNT}] options. You've sent #{options.count}: #{options}."
        )
        false
      end

      register(:update_password, self)
    end
  end
end
