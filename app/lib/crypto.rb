module Crypto
  def self.encrypt(string)
    cipher = cipher_client
    encrypted = cipher.update(string) + cipher.final
    Base64.urlsafe_encode64(encrypted, padding: false)
  end

  def self.decrypt(token)
    encrypted_data = Base64.urlsafe_decode64(token)
    cipher = cipher_client(encript: false)
    cipher.update(encrypted_data) + cipher.final
  rescue OpenSSL::Cipher::CipherError
    nil
  end

  def self.cipher_client(encript: true)
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    encript ? cipher.encrypt : cipher.decrypt
    cipher.key = Rails.application.credentials.crypto[:key]
    cipher.iv = Rails.application.credentials.crypto[:iv]
    cipher
  end
end
