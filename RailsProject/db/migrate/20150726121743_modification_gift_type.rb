class ModificationGiftType < ActiveRecord::Migration
  def change
  	change_column :carts, :gift_id, :integer, :null => true
  end
end
