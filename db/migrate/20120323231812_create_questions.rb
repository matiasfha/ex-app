class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :user_id
      t.string :name
      t.integer :value

      t.timestamps
    end
  end
end
