class RecipeStep < ApplicationRecord
  belongs_to :recipe

  validate :recipe_id, presence: true
end
