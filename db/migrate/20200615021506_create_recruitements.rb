class CreateRecruitements < ActiveRecord::Migration[6.0]
  def change
    create_table :recruitements, id: :uuid  do |t|
      t.references :individual_user, null: false, foreign_key: {to_table: :users}, type: :uuid, index: false
      t.references :company_user, null: false, foreign_key: {to_table: :users}, type: :uuid, index: false

      t.timestamps
      t.index [:individual_user_id, :company_user_id]
    end
  end
end
