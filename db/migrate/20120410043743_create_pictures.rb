class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.string :internal_link #DEBUG: is it a string or text?
      t.references :user  #user_id column
      t.references :album #album_id column
      t.timestamps
      
    end
  end
end
