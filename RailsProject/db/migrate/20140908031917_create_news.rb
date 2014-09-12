class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.datetime :date
      t.integer :author_id

      t.timestamps
    end
  end
end
