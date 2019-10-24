class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_steps

  validate :user_id, precense: true
end
