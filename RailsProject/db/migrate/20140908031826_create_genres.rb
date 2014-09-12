class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :style_name
      t.string :color_name
      t.string :color_hexa

      t.timestamps
    end
  end
end
