class DropDepartments2 < ActiveRecord::Migration
  def up
    drop_table :Departments
  end

  def down
  end
end
