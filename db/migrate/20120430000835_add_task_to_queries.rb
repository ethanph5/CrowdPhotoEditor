class AddTaskToQueries < ActiveRecord::Migration
  def change
    add_column :queries, :task, :string
  end
end
