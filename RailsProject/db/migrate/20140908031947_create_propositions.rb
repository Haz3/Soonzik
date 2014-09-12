class CreatePropositions < ActiveRecord::Migration
  def change
    create_table :propositions do |t|
      t.integer :artist_id
      t.integer :album_id
      t.integer :state
      t.datetime :date_posted

      t.timestamps
    end
  end
end
