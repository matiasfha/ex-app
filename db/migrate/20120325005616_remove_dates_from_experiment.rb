class RemoveDatesFromExperiment < ActiveRecord::Migration
  def up
    remove_column :experiments, :start_date
        remove_column :experiments, :end_date
      end

  def down
    add_column :experiments, :end_date, :date
    add_column :experiments, :start_date, :date
  end
end
