class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules, id: :uuid do |t|
      t.references :requester, null: false, foreign_key: {to_table: :users}, type: :uuid, index: false
      t.references :responder, null: false, foreign_key: {to_table: :users}, type: :uuid, index: false
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :approved_at

      t.timestamps
      t.index [:requester_id, :responder_id]
    end
  end
end
