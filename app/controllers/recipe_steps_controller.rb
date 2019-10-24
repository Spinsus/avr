# frozen_string_literal: true

class RecipeStepsController < ApplicationController
  private

  def recipe_step_params
    params.require(:recipe_step).permit(:title, :description, :recipe_id)
  end
end
