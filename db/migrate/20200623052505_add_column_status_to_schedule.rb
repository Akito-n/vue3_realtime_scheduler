class AddColumnStatusToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :status, :integer, default: 0, null: false
  end
end
