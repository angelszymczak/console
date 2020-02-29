module Console
  class Prompt
    def self.run!(options)
      setup(options[:persisted])
    end

    def self.setup(persist_file)
      app_login
      store_setup(persist_file)
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

    def self.store_setup(persist_file)
      store =
        if persist_file.nil?
          Store.build([initial_user], initial_directory)
        elsif Store.exists?(persist_file)
          Store.load(persist_file)
        else
          Store.build([initial_user], initial_directory, persist_file)
        end

      User.store = store
      Filesystem.store = store
    end

    def self.initial_directory
      Filesystem.initial_filesystem
    end

    private_class_method :setup, :app_login, :store_setup, :initial_directory
  end
end
