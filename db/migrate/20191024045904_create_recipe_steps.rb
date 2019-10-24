class CreateRecipeSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :recipe_steps do |t|
      t.string :title
      t.text :description
      t.text :order
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
