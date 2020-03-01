module Console
  class Prompt
    def self.run!(options)
      setup(options[:persisted])

      while (input = read_input)
        next if input.empty?

        puts output(input)
      end
    end

    def self.setup(persist_file)
      app_login
      store_setup(persist_file)
      initial_login
    end

    def self.app_login
      loop do
        puts "Please enter #{ENV.fetch('COMPANY_NAME')} App Key: ".important
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

      Filesystem.store = store
      User.store = store
    end

    def self.initial_directory
      Filesystem.initial_filesystem
    end

    def self.initial_user
      loop do
        username, password = ask_username_password('Please create first super user: ')
        if (user = User.new(username, password, :super)).valid_profile?
          puts "First user [#{user}] was created".success
          return user
        else
          puts user.full_error_messages.error
        end
      end
    end

    def self.initial_login
      loop do
        username, password = ask_username_password('Initial login: ')
        unless (user = User.login(username, password)).nil?
          puts "Initial #{user} logged".success
          break
        else
          puts 'Invalid credentials'.error
        end

        break unless User.current_user.nil?
      end
    end

    def self.ask_username_password(label)
      puts label.important

      print 'Please input [username]: '.ask
      username = gets.chomp

      print 'Please input [password]: '.ask
      password = gets.chomp

      [username, password]
    end

    def self.read_input
      print "#{User.current_user.symbol} ".ask
      gets.chomp
    end

    def self.output(input)
      if (cmd = Commands::Command.build!(input)).valid?
        cmd.exec.success
      else
        cmd.error_message.error
      end
    rescue Console::Commands::MalFormed => e
      e.message.error
    end

    private_class_method :setup, :app_login, :store_setup, :initial_directory, :initial_user,
      :initial_login, :ask_username_password, :output
  end
end
