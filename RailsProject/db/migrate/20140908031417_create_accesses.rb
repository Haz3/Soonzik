class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.integer :group_id
      t.string :controllerName
      t.string :actionName

      t.timestamps
    end
  end
end
