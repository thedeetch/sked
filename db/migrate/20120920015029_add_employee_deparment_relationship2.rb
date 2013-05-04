class AddEmployeeDeparmentRelationship2 < ActiveRecord::Migration
  def up
    create_table :employees_departments, :id => false do |t|
      t.integer :employee_id
      t.integer :department_id
    end
  end

  def down
    drop_table :employees_departments
  end
end
