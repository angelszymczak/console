module Console
  class KeyGenerator
    def self.generate!(secret)
      puts Digest::SHA256.hexdigest(secret)
    end
  end
end
