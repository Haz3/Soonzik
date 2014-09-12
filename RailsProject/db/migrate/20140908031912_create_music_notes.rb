class CreateMusicNotes < ActiveRecord::Migration
  def change
    create_table :music_notes do |t|
      t.integer :user_id
      t.integer :album_id
      t.integer :value

      t.timestamps
    end
  end
end
