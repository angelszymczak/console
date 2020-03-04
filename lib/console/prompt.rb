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
      if persist_file.nil?
        build_store
      elsif Store.exists?(persist_file)
        Store.load!.tap do |store|
          Filesystem.store = store
          User.store = store

          Filesystem.pwd = store.filesystem.root!
        end
      else
        build_store
      end
    end

    def self.build_store
      Store.new.tap do |store|
        Filesystem.store = store
        User.store = store

        store.filesystem = Filesystem.initial_filesystem.root!
        user = initial_user
        store.users << user

        Filesystem.pwd = store.filesystem
        User.current_user = user
      end
    end

    def self.initial_user
      loop do
        username, password = ask_username_password('Please create first super user: ')
        msg = output("create_user #{username} #{password} -role=super -first=1")

        if msg.match?(/created/)
          puts msg.success
          return User.users.last
        else
          puts msg.error
        end
      end
    end

    def self.initial_login
      loop do
        username, password = ask_username_password('Initial login: ')

        if (msg = output("login #{username} #{password}")).match?(/Logged/)
          puts msg.success
          return
        else
          puts msg.error
        end
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

    private_class_method :setup, :app_login, :store_setup, :build_store, :initial_user,
      :initial_login, :ask_username_password, :output
  end
end
