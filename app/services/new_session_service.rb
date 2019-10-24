# frozen_string_literal: true

class NewSessionService < BaseService
  attr_reader :email, :password

  def initialize(email, password)
    @email = email
    @password = password
  end

  private

  def user
    @user ||= User.find_by(email: email)
  end

  def password_valid?
    return true
    user && user.authenticate(password)
  end

  def payload
    if password_valid?
      @data = Api::JwtTokenGenerator.encode(contents)
    else
      errors.add(:base, "Invalid E-mail or password, please try again.")
    end
  end

  def contents
    {
      user_id: user.id,
      exp: 24.hours.from_now.to_i
    }
  end
end
