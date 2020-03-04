module Console
  module Commands
    class Destroy < Filesystem
      ARGS_COUNT = 1
      OPTIONS_COUNT = 0

      def perform
        unless Console::Filesystem.destroy(@directory, @target).nil?
          "Item [#{arguments.join}] was destroyed."
        else
          "No such file or directory: [#{arguments.join}]"
        end
      end

      def allow?
        return true if @allowance.allow? { Console::User.current_user.super? }

        @errors[:permissions] = @allowance.message
        false
      end

      def valid?
        super() && valid_exceptional_arguments?
      end

      def valid_exceptional_arguments?
        return true unless Console::Filesystem.root_path?(arguments.join)

        @errors[:arguments] = MalFormed.new("Cannot destroy directory [#{arguments.join}].")
        false
      end

      register(:destroy, self)
    end
  end
end
