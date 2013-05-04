class Changecolumnname < ActiveRecord::Migration
  def up
  rename_column :shifts, :start_date, :start
  rename_column :shifts, :end_date, :end
  end

  def down
  end
end
