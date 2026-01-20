class CreateDailyActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :daily_activities do |t|
      t.references :sankalp, null: false, foreign_key: true
      t.date :activity_date, null: false
      t.text :notes
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
    add_index :daily_activities, [ :sankalp_id, :activity_date ], unique: true
    add_index :daily_activities, :activity_date
  end
end
