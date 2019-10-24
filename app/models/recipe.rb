class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_steps

  validates :user_id, :title, :description, presence: true
end
