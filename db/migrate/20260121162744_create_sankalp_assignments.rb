class CreateSankalpAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :sankalp_assignments do |t|
      t.references :sankalp, null: false, foreign_key: { to_table: :sankalps }
      t.references :user, null: false, foreign_key: { to_table: :sankalp_users }

      t.timestamps
    end
    
    add_index :sankalp_assignments, [ :sankalp_id, :user_id ], unique: true
  end
end
