module Tokenable
  extend ActiveSupport::Concern

  def token
    Crypto.encrypt(id.to_s)
  end

  class_methods do
    def find_by_token(token)
      find(Crypto.decrypt(token))
    rescue ArgumentError
      raise ActiveRecord::RecordNotFound
    end
  end
end
