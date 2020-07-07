class AddColumSomecolumnsToOccupation < ActiveRecord::Migration[6.0]
  def change
    add_column :occupations, :apply_from, :integer, default: 0, null: false
    add_column :occupations, :required_time, :integer
    add_column :occupations, :address, :string
    add_column :occupations, :item, :string
    add_column :occupations, :memo, :text
  end
end
