class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :numberStreet
      t.string :complement, :null => false
      t.string :street
      t.string :city
      t.string :country
      t.string :zipcode

      t.timestamps
    end
  end
end
