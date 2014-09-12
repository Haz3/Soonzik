class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.integer :user_id
      t.integer :album_id
      t.string :title
      t.integer :duration
      t.string :style
      t.float :price
      t.string :file
      t.boolean :limited

      t.timestamps
    end
  end
end
