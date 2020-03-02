module Console
  module Commands
    class CreateUser < User
      ARGS_COUNT = 2
      OPTIONS_COUNT = 1
      ROLE_FLAG = '-role'

      def perform
        if (new_user = Console::User.create(*arguments, options['-role'])).valid?
          "User [#{new_user.username}:#{new_user.role}] was created."
        else
          new_user.error_message
        end
      end

      def valid_options?
        valid_options_count? && valid_role_flag? && valid_role?
      end

      private

      def valid_options_count?
        return true if options.keys.count == OPTIONS_COUNT

        @errors[:options] = MalFormed.new(
          "Expected [#{OPTIONS_COUNT}] options. You've sent #{options.count}: #{options}."
        )
        false
      end

      def valid_role_flag?
        return true if options.key?(ROLE_FLAG)

        @errors[:options] = MalFormed.new(
          "Expected #{ROLE_FLAG} flag. You have sent [#{options.keys}]."
        )
        false
      end

      def valid_role?
        return true if Console::User::ROLES.key?(options[ROLE_FLAG].to_sym)

        @errors[:options] = MalFormed.new(
          "Expected [#{Console::User::ROLES}] role options. You have sent [#{options[ROLE_FLAG]}]."
        )
        false
      end

      register(:create_user, self)
    end
  end
end
