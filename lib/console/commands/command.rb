module Console
  module Commands
    class Command
      OPTION_JOINER = '='
      OPTION_DASH = '-'
      COMMAND_SEPARATOR = ' '

      @@commands = {}

      # Store a hash of classes that build
      #   - { action_1: CommandAction1, action_2: CommandAction2, .. }
      def self.commands
        @@commands
      end

      def self.register(action, command)
        @@commands[action] = command
      end

      def self.build!(input)
        action, tail_input = input.split(COMMAND_SEPARATOR, 2)
        command = parse_command(action)

        array_input = command.split_arguments(tail_input)
        arguments = command.parse_arguments(array_input)
        options = command.parse_options(array_input)
        raise MalFormed, "Malformed command: [#{input}]." if array_input.any?

        command.new(arguments, options)
      end

      def self.parse_command(action)
        raise MalFormed, 'Empty command.' if action.nil?
        return commands[action.to_sym] unless  (commands[action.to_sym]).nil?
        raise MalFormed, "Unknow command [#{action}]."
      end

      def self.split_arguments(input)
        (input || '').split(COMMAND_SEPARATOR)
      end

      def self.parse_arguments(input)
        index = (limit = options_index(input)).nil? ? input.length : limit

        input.shift(index)
      end

      def self.parse_options(input)
        if input.all? { |option| option_input?(option) }
          input
            .map { |option| option.split(OPTION_JOINER, 2) }
            .to_h
            .tap { input.clear }
        else
          raise MalFormed, "Malformed options: [#{input.join(' ')}]."
        end
      end

      def self.options_index(input)
        input.index { |i| option_input?(i) }
      end

      def self.option_input?(input)
        input.start_with?(OPTION_DASH) && input.include?(OPTION_JOINER)
      end

      private_class_method :commands, :options_index, :option_input?

      attr_accessor :arguments, :options, :errors

      # arguments [Array<String>]: list of commmand's arguments
      #   - command ARG_1 ARG_2 ...
      #
      # options [Hash{ option: value }]: the option comes together with value by an '='.
      #   - command ARG_1 ARG_2 OPTION=value ...
      #
      # In this order, if command comes mixed, validation throw a malformed error.
      def initialize(arguments, options)
        @errors = {}
        @allowance = Allowance.new

        self.arguments = arguments
        self.options = options
      end

      def exec
        allow? ? perform : @allowance.message
      end

      def valid?
        valid_arguments? && valid_options?
      end

      def exit_session
        exit
      end

      def valid_arguments?
        valid_arguments_count?
      end

      def valid_options?
        valid_options_count?
      end

      def error_message
        @errors
          .map { |error, msg| "#{error}: #{msg}" }
          .join(' ')
      end

      protected

      def allow?
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def perform
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def valid_arguments_count?
        return true if arguments_condition

        @errors[:arguments] = MalFormed.new(
          "Expected #{self.class::ARGS_COUNT} args. You've sent #{arguments.count}: #{arguments}."
        )
        false
      end

      def arguments_condition
        arguments.count == self.class::ARGS_COUNT
      end

      def valid_options_count?
        return true if options.keys.count == self.class::OPTIONS_COUNT

        @errors[:options] = MalFormed.new("Unexpected options: [#{options}].")
        false
      end
    end
  end
end
