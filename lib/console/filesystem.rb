module Console
  class Filesystem
    DIRECTORY_SEPARATOR = '/'

    @@store = nil
    @@pwd = nil

    def self.store
      @@store
    end

    def self.store=(store)
      @@store = store
    end

    def self.pwd
      @@pwd
    end

    def self.pwd=(folder)
      @@pwd = folder
    end

    # Build a new directory with root name '/'
    #
    # @returns [Folder < Filesystem]
    def self.initial_filesystem
      Folder.new(DIRECTORY_SEPARATOR)
    end

     attr_accessor :name, :parent

    def initialize(name, parent = nil)
      self.name = name
      self.parent = parent
    end
  end
end
