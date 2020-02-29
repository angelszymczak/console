module Console
  class User
    extend Forwardable

    @@store = nil
    @@current_user = nil

    def self.store
      @@store
    end

    def self.store=(store)
      @@store = store
    end

    def self.current_user
      @@current_user
    end

    def self.current_user=(user)
      @@current_user = user
    end
    def_delegator self, :current_user=

    def self.login(username, password)
      return if (user = find_by(username)).nil?

      user.login(password)
    end

    def self.find_by(username)
      users.find { |u| u.username == username }
    end

    def self.users
      store.users
    end

    private_class_method :users, :find_by

    MAX_NAME_SIZE = 255
    MIN_NAME_SIZE = 8
    PASSWORD_SIZE = 8
    WHITESPACE = /\s/

    ROLES = { super: '#', regular: '$',  read_only: '>' }

    attr_accessor :username, :password, :role
    attr_reader :errors

    def initialize(username, password, role)
      @errors = {}

      self.username = username
      self.password = password
      self.role = role
    end

    def password=(password)
      @password = secure_password(password) if valid_plain_password?(password)
    end

    def login(plain_password)
      return unless self.password == secure_password(plain_password)

      self.current_user = self
    end

    def secure_password(plain_password)
      KeyGenerator.generate!(ENV.fetch('SECRET') + plain_password)
    end

    def valid_profile?
      valid_username? && valid_password?
    end

    def valid_username?
      valid_username_size? && free_blank_field?(:username, username)
    end

    def valid_password?
      !password.nil? && valid_password_size?(password) && free_blank_field?(:password, password)
    end

    def valid_plain_password?(pass)
      valid_password_size?(pass) && free_blank_field?(:password, pass)
    end

    def valid_username_size?
      return true if username.size <= MAX_NAME_SIZE && username.size >= MIN_NAME_SIZE

      @errors[:username] = Error.new(
        "Username size must be in [#{MAX_NAME_SIZE}..#{MIN_NAME_SIZE}] by [#{username.size}]."
      )
      false
    end

    def valid_password_size?(pass)
      return true if pass.size >= PASSWORD_SIZE

      @errors[:password] = Error.new("Password must have [#{PASSWORD_SIZE}] characters.")
      false
    end

    def free_blank_field?(attr, value)
      return true unless value.match(WHITESPACE)

      @errors[attr] = Error.new("#{attr.to_s.capitalize} can't have whitespaces.")
      false
    end

    def full_error_messages
      @errors.values.join(' ')
    end

    def to_s
      "#{role} -> #{username}"
    end

    def super?
      role == :super
    end

    def regular?
      role == :regular
    end

    def read_only?
      role == :read_only
    end

    def symbol
      ROLES[role]
    end

    class Error < StandardError; end
  end
end
