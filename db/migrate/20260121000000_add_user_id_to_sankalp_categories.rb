class AddUserIdToSankalpCategories < ActiveRecord::Migration[8.1]
  def change
    add_reference :sankalp_categories, :user, null: true, foreign_key: { to_table: :sankalp_users }
  end
end
