class AddKeywordsQuestionToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :keywords_question, :string

  end
end
