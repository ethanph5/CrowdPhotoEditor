class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name #with a column called "name" of type "string"
      t.string :password #and a column called "password" of type "string"
      t.float :credit, :default => 0
      t.string :email, :null => false
      t.timestamps
    end
  end
end

