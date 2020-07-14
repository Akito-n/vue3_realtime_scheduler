class AddStageToRecruitements < ActiveRecord::Migration[6.0]
  def change
    add_column :recruitements, :stage, :integer, null: false, default: 1, comment: '応募の状態（1次面接通過など）'
  end
end
