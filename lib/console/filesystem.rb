module Console
  class Filesystem
    DIRECTORY_SEPARATOR = '/'

    def self.store
      @@store ||= nil
    end

    def self.store=(store)
      @@store = store
    end

    # Build a new directory with root name '/'
    #
    # @returns [Folder < Filesystem]
    def self.initial_filesystem
      Folder.new(DIRECTORY_SEPARATOR)
    end

    attr_accessor :name

    def initialize(name)
      self.name = name
    end
  end
end
