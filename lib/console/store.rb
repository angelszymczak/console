module Console
  class Store
    PREFIX_PATH = 'db/'

    extend Forwardable

    @@path = nil

    # When check existence set the persist file path
    def self.exists?(persist_file)
      self.path = persist_file
      ::File.exists?(self.path)
    end

    # Load serialized store object file
    #
    # returns [Store]
    def self.load!
      Marshal.load(::File.read(path))
    rescue ArgumentError
      puts 'Incompatible data type (can\'t be load).'
      exit
    rescue TypeError
      puts 'Incompatible marshal file format (can\'t be read).'
      exit
    end

    def self.path
      @@path
    end
    def_delegator self, :path

    def self.path=(persist_file)
      @@path = "#{PREFIX_PATH}#{persist_file}"
    end
    def_delegator self, :path=

    attr_accessor :users, :filesystem

    def initialize(users = [], filesystem = nil)
      self.users = users
      self.filesystem = filesystem
    end

    # Exec a task and then persis if persistible
    def storing
      if block_given?
        yield
      end.tap { persist! if persistible? }
    end

    def persistible?
      !!self.path
    end

    # Serialize store amd write file
    #
    # returns [Serialized<Store>]
    def persist!
      ::File.write(self.path, Marshal.dump(self))
    rescue => e
      puts e.message
      exit
    end

    private

    def marshal_dump
      {
        users: users,
        filesystem: filesystem
      }
    end

    def marshal_load(serialized)
      self.users = serialized[:users]
      self.filesystem = serialized[:filesystem]
    end
  end
end
