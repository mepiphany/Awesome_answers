class AddViewCountToQuestions < ActiveRecord::Migration
  def change
    #use to add columns
      add_column :questions, :view_count, :integer
  end
end
