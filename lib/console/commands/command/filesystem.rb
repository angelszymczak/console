module Console
  module Commands
    class Filesystem < Command
      def valid?
        super() && valid_path?
      end

      def valid_path?
        path = arguments.join
        @directory, @target, array_path = Console::Folder.directory_target_path(path)
        @directory = Console::Folder.seek(@directory, array_path) unless array_path.empty?
        return true unless @directory.nil?

        @errors[:arguments] = MalFormed.new("No such file or directory: [#{path}]")
        false
      end

      def allow?
        return true if @allowance.allow? { Console::User.current_user.super? }

        @errors[:permissions] = @allowance.message
      end
    end
  end
end
