class CreateSankalps < ActiveRecord::Migration[8.1]
  def change
    create_table :sankalps do |t|
      t.string :title, null: false
      t.text :description
      t.integer :status, null: false, default: 0
      t.date :start_date, null: false
      t.date :end_date
      t.references :user, null: false, foreign_key: { to_table: :sankalp_users }
      t.references :category, null: false, foreign_key: { to_table: :sankalp_categories }
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :sankalps, :status
    add_index :sankalps, :deleted_at
  end
end
