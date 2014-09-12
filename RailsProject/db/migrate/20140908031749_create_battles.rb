class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
      t.datetime :date_begin
      t.datetime :date_end
      t.integer :artist_one_id
      t.integer :artist_two_id

      t.timestamps
    end
  end
end
