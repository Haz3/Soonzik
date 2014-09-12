class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :salt
      t.string :fname, :null => false
      t.string :lname, :null => false
      t.string :username
      t.date :birthday
      t.string :image
      t.text :description, :null => false
      t.string :phoneNumber, :null => false
      t.integer :adress_id, :null => false
      t.string :facebook, :null => false
      t.string :twitter, :null => false
      t.string :googlePlus, :null => false
      t.datetime :signin
      t.string :idAPI
      t.string :secureKey
      t.boolean :activated
      t.boolean :newsletter
      t.string :language

      t.timestamps
    end
  end
end
