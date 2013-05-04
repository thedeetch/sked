class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :id
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
