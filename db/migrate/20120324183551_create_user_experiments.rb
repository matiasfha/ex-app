class CreateUserExperiments < ActiveRecord::Migration
  def change
    create_table :user_experiments do |t|
      t.integer :experiment_id
      t.integer :user_id

      t.timestamps
    end
  end
end
