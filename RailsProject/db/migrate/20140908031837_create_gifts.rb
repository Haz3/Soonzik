class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.integer :to_user
      t.integer :from_user
      t.string :typeObj
      t.integer :obj_id

      t.timestamps
    end
  end
end
