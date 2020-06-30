class RenameSubjectColumnToOccupations < ActiveRecord::Migration[6.0]
  def change
    rename_column :occupations, :subject, :name
  end
end
