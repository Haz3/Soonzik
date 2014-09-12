class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :battle_id
      t.integer :artist_id

      t.timestamps
    end
  end
end
