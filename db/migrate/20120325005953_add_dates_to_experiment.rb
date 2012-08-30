class AddDatesToExperiment < ActiveRecord::Migration
  def change
    add_column :experiments, :start_date, :date, :default => Time.now

    add_column :experiments, :end_date, :date, :default => Time.now

  end
end
