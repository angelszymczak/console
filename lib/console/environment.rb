module Console
  class Environment
    CONFIG_FILE = 'config.yml'

    def self.load_variables
      ENV['APP_KEY'] = ENV.fetch('APP_KEY', look_up('APP_KEY'))
      ENV['SECRET'] = ENV.fetch('SECRET', look_up('SECRET'))
      ENV['COMPANY_NAME'] = ENV.fetch('COMPANY_NAME', look_up('COMPANY_NAME'))
    rescue MissingConfigError, MissingVariableError => e
      puts e.message
      exit
    ensure
      remove_instance_variable(:@config) unless @config.nil?
    end

    def self.look_up(variable)
      return config[variable] if config.key?(variable)

      raise MissingVariableError, "Environment variable #{variable} not provided."
    end

    def self.config
      @config ||= YAML.load_file(CONFIG_FILE).tap do |result|
        raise MissingConfigError, 'Configuation not provided.' unless result
      end
    end

    private_class_method :config

    class MissingVariableError < StandardError; end
    class MissingConfigError < StandardError; end
  end

  Environment.load_variables
end
