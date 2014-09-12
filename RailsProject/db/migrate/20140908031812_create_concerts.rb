class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.integer :user_id
      t.datetime :planification
      t.integer :address_id
      t.string :url, :null => false

      t.timestamps
    end
  end
end
