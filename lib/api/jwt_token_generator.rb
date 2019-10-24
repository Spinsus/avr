# frozen_string_literal: true

module Api
  class JwtTokenGenerator
    def self.encode(payload)
      JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
    end

    def self.decode(token)
      JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')[0]
    rescue JWT::ExpiredSignature
      nil
    end
  end
end
