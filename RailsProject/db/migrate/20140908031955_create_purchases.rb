class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.string :typeObj
      t.integer :obj_id
      t.datetime :date

      t.timestamps
    end
  end
end
