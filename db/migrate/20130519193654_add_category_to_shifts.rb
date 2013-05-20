class AddCategoryToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :category, :string
  end
end
