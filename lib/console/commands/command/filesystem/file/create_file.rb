module Console
  module Commands
    class CreateFile < File
      ARGS_COUNT = 2
      MAX_OPTIONS_COUNT = 1
      METADATA_FLAG = '-type'

      def perform
        new_file = Console::File.create(@directory, @target, @content, options[METADATA_FLAG])
        if new_file.valid?
          "Folder [#{new_file.path}] was created."
        else
          new_file.error_message
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

      def valid_path?
        @content = arguments.pop
        super()
      end

      def valid_namespace?
        return true if @directory.find_item_by(@target).nil?

        @errors[:arguments] = MalFormed.new("Namespace has been taken: [#{arguments.join}].")
        false
      end

      def valid_options?
        valid_options_count? && valid_metadata_flag?
      end

      private

      def valid_options_count?
        return true if options.keys.count <= MAX_OPTIONS_COUNT

        @errors[:options] = MalFormed.new(
          "Expected [#{MAX_OPTIONS_COUNT}] options. You've sent #{options.count}: #{options}."
        )
        false
      end

      def valid_metadata_flag?
        return true if options.keys.count == 0
        return true if options.key?(METADATA_FLAG)

        @errors[:options] = MalFormed.new(
          "Expected #{METADATA_FLAG} flag. You have sent [#{options.keys}]."
        )
        false
      end

      register(:create_file, self)
    end
  end
end
