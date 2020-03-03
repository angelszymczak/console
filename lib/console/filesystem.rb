module Console
  class Filesystem < Base
    DIRECTORY_SEPARATOR = '/'
    ALLOWED_CHARS_REGEX = /^[a-zA-Z0-9_.-]*$/
    MAX_NAME_SIZE = 255 # Bytes 2^8

    extend Forwardable

    @@store = nil
    @@pwd = nil
    @@root = nil

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

    def self.root
      @@root
    end
    def_delegator self, :root

    def self.root=(folder)
      @@root = folder
    end
    def_delegator self, :root=

    # Build a new directory with root name '/'
    #
    # @returns [Folder < Filesystem]
    def self.initial_filesystem(name = nil)
      Folder.new(name || DIRECTORY_SEPARATOR).tap do |folder|
        folder.root!
      end
    end

    attr_accessor :name, :parent

    def initialize(name)
      super()

      self.name = name
      self.parent = parent
    end

    def file?
      false
    end

    def folder?
      false
    end

    def path
      return "#{name}" if root?

      parent.path.concat(DIRECTORY_SEPARATOR).concat(name)
    end

    def root?
      self == root
    end

    def valid?
      valid_name_format? && valid_name_size?
    end

    def valid_name_format?
      return true if ALLOWED_CHARS_REGEX.match?(name)

      @errors[:name] = Error.new(
        "Name [#{name}] invalid format. Only can use chars within [#{ALLOWED_CHARS_REGEX}]."
      )
      false
    end

    def valid_name_size?
      return true if name.size <= MAX_NAME_SIZE

      @errors[:name] = Error.new(
        "Name [#{name}] exceed limit size [#{MAX_NAME_SIZE}] by [#{name.size}]."
      )
      false
    end

    def <=>(other)
      name <=> other.name
    end

    def to_s
      name
    end
  end
end
