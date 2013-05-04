class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.integer :id
      t.string :name
      t.time :open_time
      t.time :close_time

      t.timestamps
    end
  end
end
