class CreateBlankSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :blank_schedules, id: :uuid do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
