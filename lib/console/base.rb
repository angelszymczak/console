module Console
  class Base
    include Comparable

    attr_reader :errors

    def initialize
      @errors = {}
    end

    def valid?
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def error_message
      @errors.map { |error, msg| msg }.join(' ')
    end

    def <=>(_other)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def to_s
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    class Error < StandardError; end
  end
end
