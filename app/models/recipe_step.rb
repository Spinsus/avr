class RecipeStep < ApplicationRecord
  belongs_to :recipe

  validates :recipe_id, :title, :description, :order, presence: true
end
