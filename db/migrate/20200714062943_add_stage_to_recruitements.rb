class AddStageToRecruitements < ActiveRecord::Migration[6.0]
  def change
    add_column :recruitements, :stage_count, :integer, null: false, default: 1, comment: '応募回数（ex: 「1」次面接）'
  end
end
