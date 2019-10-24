# frozen_string_literal: true

class AuthenticationService < BaseService
  private

  attr_reader :headers

  def initialize(headers)
    @headers = headers
    @user = nil
  end

  def payload
    return unless token_present?
    @data = user if user
  end

  def user
    @user ||= User.find_by(id: user_id)
    @user || errors.add(:token, I18n.t('decode_authentication_command.token_invalid')) && nil
  end

  def token_present?
    token.present? && token_payload.present?
  end

  def token
    return auth_header.split(' ').last if auth_header.present?
    errors.add(:token, I18n.t('decode_authentication_command.token_missing'))
    nil
  end

  def auth_header
    headers['Authorization']
  end

  def token_payload
    @token_payload ||= begin
      decoded = Api::JwtTokenGenerator.decode(token)
      errors.add(:token, I18n.t('decode_authentication_command.token_expired')) unless decoded
      decoded
    end
  end

  def user_id
    token_payload['user_id']
  end
end
