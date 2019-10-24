# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  attr_encrypted :current_sign_in_ip,
  				 key: Figaro.env.user_current_sign_in_ip_key

  attr_encrypted :last_sign_in_ip,
  				 key: Figaro.env.user_last_sign_in_ip_key

  has_many :recipes
end
