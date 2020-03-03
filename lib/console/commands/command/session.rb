module Console
  module Commands
    class Session < Command
      def allow?
        return true if @allowance.allow? do
          Console::User.current_user.super? ||
            Console::User.current_user.regular? ||
            Console::User.current_user.read_only?
        end

        @errors[:permissions] = @allowance.message
        false
      end

      def valid_options?
        return true if options.empty?

        @errors[:options] = MalFormed.new("Unexpected options: [#{options}].")
        false
      end
    end
  end
end
