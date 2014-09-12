class CreateInfluences < ActiveRecord::Migration
  def change
    create_table :influences do |t|
      t.string :name

      t.timestamps
    end
  end
end
