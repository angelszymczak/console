module Console
  module Commands
    class Session < Command
      def allow?
        true
      end

      def valid_options?
        return true if options.empty?

        @errors[:options] = MalFormed.new("Unexpected options: [#{options}].")
        false
      end
    end
  end
end
