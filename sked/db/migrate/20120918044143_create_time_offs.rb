class CreateTimeOffs < ActiveRecord::Migration
  def change
    create_table :time_offs do |t|
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
