class CreateListenings < ActiveRecord::Migration
  def change
    create_table :listenings do |t|
      t.integer :user_id
      t.integer :music_id
      t.datetime :when
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
