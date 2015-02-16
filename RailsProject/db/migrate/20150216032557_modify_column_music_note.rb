class ModifyColumnMusicNote < ActiveRecord::Migration
  def change
  	rename_column :music_notes, :album_id, :music_id
  end
end
