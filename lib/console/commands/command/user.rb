module Console
  module Commands
    class User < Command
      FIRST_USER_OPTIONS_COUNT = 2
      FIRST_USER_FLAG = '-first'

      def allow?
        return true if @allowance.allow? { first_user? || Console::User.current_user.super? }

        @errors[:permissions] = @allowance.message
        false
      end

      # Don't notify if it fails by first-user flags
      def first_user?
        return false unless options.keys.count == FIRST_USER_OPTIONS_COUNT
        return false unless options.key?(FIRST_USER_FLAG)

        Console::User.first_user?(options[FIRST_USER_FLAG])
      end
    end
  end
end
