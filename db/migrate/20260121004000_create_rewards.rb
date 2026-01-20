class CreateRewards < ActiveRecord::Migration[8.1]
  def change
    create_table :rewards do |t|
      t.references :user, null: false, foreign_key: { to_table: :sankalp_users }
      t.references :sankalp, null: true, foreign_key: { to_table: :sankalps }
      t.string :title
      t.text :message
      t.string :icon
      t.datetime :read_at

      t.timestamps
    end
  end
end
