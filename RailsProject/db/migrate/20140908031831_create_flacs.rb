class CreateFlacs < ActiveRecord::Migration
  def change
    create_table :flacs do |t|
      t.integer :music_id
      t.string :file

      t.timestamps
    end
  end
end
