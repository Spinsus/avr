# frozen_string_literal: true

class RecipesController < ApplicationController
	authorize_resource

	private

	def recipe_params
    params.require(:recipe).permit(:title, :description, :user_id)
	end

	def query_params
		{ user_id: current_user.id }
	end
end
