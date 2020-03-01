module Console
  module Commands
    class Allowance
      attr_accessor :allow, :message

      def initialize(allow = nil, message = nil)
        self.allow = allow
        self.message = message
      end

      def allow?
        return true if yield

        self.message = 'There aren\'t enough permissions'
        self.allow = false
      end
    end
  end
end
