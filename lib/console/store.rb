module Console
  class Store
    PREFIX_PATH = 'db/'

    extend Forwardable

    # Build new ´Store´ instance, if ´persist_file´ is present, then will be persisted.
    #
    # users [Array<User>]
    # filesystem [Filesystem::Folder]
    # persist_file [String]: file name to data persist
    #
    # returns [Store]
    def self.build(users, filesystem, persist_file = nil)
      new(users, filesystem).tap do |str|
        unless persist_file.nil?
          str.path = PREFIX_PATH + persist_file
          str.persist!
        end
      end
    end

    def self.exists?(persist_file)
      ::File.exists?(PREFIX_PATH + persist_file)
    end

    # Load serialized store object file
    #
    # returns [Store]
    def self.load(persist_file)
      Marshal.load(::File.read(PREFIX_PATH + persist_file))
    rescue ArgumentError
      puts 'Incompatible data type (can\'t be load).'
      exit
    rescue TypeError
      puts 'Incompatible marshal file format (can\'t be read).'
      exit
    end

    attr_accessor :users, :filesystem, :path

    def initialize(users, filesystem)
      self.users = users
      self.filesystem = filesystem
    end

    # Exec a task and then persis if persistible
    def storing
      yield.tap { persist! if persistible? }
    end

    def persistible?
      !!path
    end

    # Serialize store amd write file
    #
    # returns [Serialized<Store>]
    def persist!
      ::File.write(path, Marshal.dump(self))
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