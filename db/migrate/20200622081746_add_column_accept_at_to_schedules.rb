class AddColumnAcceptAtToSchedules < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :accepted_at, :datetime
  end
end
