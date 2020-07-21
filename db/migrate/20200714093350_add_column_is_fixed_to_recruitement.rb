class AddColumnIsFixedToRecruitement < ActiveRecord::Migration[6.0]
  def change
    add_column :recruitements, :is_fixed, :boolean, default: false, comment: '応募済みの案件の面接日が全て確定しているか'
  end
end
