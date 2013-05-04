class AddEmployeeDeparmentRelationship3 < ActiveRecord::Migration
  def up
    create_table :departments_employees, :id => false do |t|
      t.integer :department_id
      t.integer :employee_id
    end
    
    drop_table :employees_departments
  end

  def down
    drop_table :departments_employees
  end
end
