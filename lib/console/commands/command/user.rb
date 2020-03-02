module Console
  module Commands
    class User < Command
      def allow?
        return true if @allowance.allow? { Console::User.current_user.super? }

        @errors[:permissions] = @allowance.message
        false
      end
    end
  end
end
