class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name #with a column called "name" of type "string"    
      t.references :user  #user_id column
      t.timestamps
    end
  end
end
