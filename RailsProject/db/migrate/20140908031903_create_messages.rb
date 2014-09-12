class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :msg
      t.integer :user_id
      t.integer :dest_id
      t.string :session

      t.timestamps
    end
  end
end
