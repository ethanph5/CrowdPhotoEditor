class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :task_link
      t.string :result_link
      t.references :user  #user_id column
      t.timestamps
    end
  end
end
