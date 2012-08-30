class CreateUserFilters < ActiveRecord::Migration
  def change
    create_table :user_filters do |t|
      t.integer :experiment_id
      t.integer :filter_type
      t.string :value

      t.timestamps
    end
  end
end
