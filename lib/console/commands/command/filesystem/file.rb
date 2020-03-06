module Console
  module Commands
    class File < Filesystem
      CONTENT_DELIMETER = /('|")/

      def valid_exceptional_arguments?
        return true unless
          Console::Filesystem.root_path?(arguments.join) ||
            arguments.join.end_with?(Console::Filesystem::DIRECTORY_SEPARATOR)

        @errors[:arguments] = MalFormed.new("Cannot create directory [#{arguments.join}].")
        false
      end
    end
  end
end
