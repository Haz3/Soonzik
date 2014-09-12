class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :user_id
      t.string :typeObj
      t.integer :obj_id
      t.boolean :gift

      t.timestamps
    end
  end
end
