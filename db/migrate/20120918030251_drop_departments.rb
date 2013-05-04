class DropDepartments < ActiveRecord::Migration
  def up
  end

  def down
    drop_table :Departments
  end
end
