class CreateOccupations < ActiveRecord::Migration[6.0]
  def change
    create_table :occupations, id: :uuid do |t|
      t.string :subject, null: false
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end

    BlankSchedule.delete_all
    Schedule.delete_all

    remove_reference :blank_schedules, :user, null: false, foreign_key: true, type: :uuid
    add_reference :blank_schedules, :schedulable, polymorphic: true, type: :uuid, null: false

    remove_reference :schedules, :requester, null: false, foreign_key: {to_table: :users}, type: :uuid, index: false
    add_reference :schedules, :requester, polymorphic: true, null: false, type: :uuid, index: false

    remove_reference :schedules, :responder, null: false, foreign_key: {to_table: :users}, type: :uuid, index: false
    add_reference :schedules, :responder, polymorphic: true, null: false, type: :uuid, index: false

    add_reference :recruitements, :occupation, null: false, type: :uuid, foreign_key: true

  end
end
