class AddTypeToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :type, :string
  end
end
