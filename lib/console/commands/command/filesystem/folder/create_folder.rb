module Console
  module Commands
    class CreateFolder < Folder
      ARGS_COUNT = 1
      OPTIONS_COUNT = 0

      def perform
        if (new_folder = Console::Folder.create(@directory, @target)).valid?
          "Folder [#{new_folder.path}] was created."
        else
          new_folder.error_message
        end
      end

      def allow?
        return true if @allowance.allow? do
          Console::User.current_user.regular? ||
            Console::User.current_user.super?
        end

        @errors[:permissions] = @allowance.message
        false
      end

      def valid?
        super() && valid_exceptional_arguments? && valid_namespace?
      end

      def valid_exceptional_arguments?
        return true unless Console::Filesystem.root_path?(arguments.join)

        @errors[:arguments] = MalFormed.new(
          "Cannot create directory [#{Console::Filesystem.root_path}]."
        )
        false
      end

      def valid_namespace?
        return true if @directory.find_item_by(@target).nil?

        @errors[:arguments] = MalFormed.new("Namespace has been taken: [#{arguments.join}].")
        false
      end

      register(:create_folder, self)
    end
  end
end
