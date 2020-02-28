module Console
  class Prompt
    def self.run!(options)
      setup(options[:persisted])
    end

    def self.setup(persist_file)
      app_login
    end

    def self.app_login
      loop do
        print "Please enter #{ENV.fetch('COMPANY_NAME')} App Key: ".important
        key = STDIN.noecho(&:gets).chomp
        if ENV.fetch('APP_KEY') == key
          puts 'App logged'.success
          break
        else
          puts 'Invalid Key App'.error
        end
      end
    end

    private_class_method :setup, :app_login
  end
end
