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

      def allow?
        return true if @allowance.allow? do
          Console::User.current_user.super? ||
            Console::User.current_user.regular?
        end

        @errors[:permissions] = @allowance.message
        false
      end

      register(:update_password, self)
    end
  end
end
