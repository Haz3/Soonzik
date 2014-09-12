class CreateNewstexts < ActiveRecord::Migration
  def change
    create_table :newstexts do |t|
      t.text :content
      t.string :title
      t.string :language
      t.integer :news_id

      t.timestamps
    end
  end
end
