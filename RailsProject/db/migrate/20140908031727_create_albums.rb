class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :user_id
      t.string :title
      t.string :style
      t.float :price
      t.string :file
      t.integer :yearProd

      t.timestamps
    end
  end
end
