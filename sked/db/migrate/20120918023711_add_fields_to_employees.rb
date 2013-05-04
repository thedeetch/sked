class AddFieldsToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :address, :string
    add_column :employees, :city, :string
    add_column :employees, :state, :string
    add_column :employees, :zip, :string
  end
end
