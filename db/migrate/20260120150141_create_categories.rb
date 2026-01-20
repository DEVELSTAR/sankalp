class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.string :color, default: "#6366f1"
      t.string :icon, default: "star"

      t.timestamps
    end
    add_index :categories, :name, unique: true
  end
end
