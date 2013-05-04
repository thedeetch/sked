class EmployeesToShifts < ActiveRecord::Migration
  def up
    add_column :shifts, :department_id, :integer
    add_column :shifts, :employee_id, :integer
  end

  def down
    remove_column :shifts, :department_id
    remove_column :shifts, :employee_id
  end
end
