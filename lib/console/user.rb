module Console
  class User
    extend Forwardable

    def self.store
      @@store ||= nil
    end

    def self.store=(store)
      @@store = store
    end

    def self.users
      store.users
    end
    def_delegator self, :users

    MAX_NAME_SIZE = 255
    MIN_NAME_SIZE = 8
    PASSWORD_SIZE = 8
    WHITESPACE = /\s/

    ROLES = { super: '#', regular: '$',  read_only: '>' }

    attr_accessor :username, :password, :role
    attr_reader :errors

    def initialize(username, password, role)
      self.username = username
      self.password = password
      self.role = role

      @errors = {}
    end

    def secure_password(plain_password)
      KeyGenerator.generate!(ENV.fetch('SECRET') + plain_password)
    end

    def valid_profile?
      valid_username? && valid_password?
    end

    def valid_username?
      valid_username_size? && free_blank_field?(:username)
    end

    def valid_password?
      return false unless valid_password_size? && free_blank_field?(:password)

      self.password = secure_password(password)
      true
    end

    def valid_username_size?
      return true if username.size <= MAX_NAME_SIZE && username.size >= MIN_NAME_SIZE

      @errors[:username] = Error.new(
        "Username size must be in [#{MAX_NAME_SIZE}..#{MIN_NAME_SIZE}] by [#{username.size}]."
      )
      false
    end

    def valid_password_size?
      return true if password.size >= PASSWORD_SIZE

      @errors[:password] = Error.new("Password must have [#{PASSWORD_SIZE}] characters.")
      false
    end

    def free_blank_field?(field)
      return true unless self.send(field).match(WHITESPACE)

      @errors[field.to_sym] = Error.new("#{field.capitalize} can't have whitespaces.")
      false
    end

    def full_error_messages
      @errors.values.join(' ')
    end

    def to_s
      username
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
