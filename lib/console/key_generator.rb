module Console
  class KeyGenerator
    def self.generate!(secret)
      Digest::SHA256.hexdigest(secret)
    end
  end
end
