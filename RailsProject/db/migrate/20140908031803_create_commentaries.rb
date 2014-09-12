class CreateCommentaries < ActiveRecord::Migration
  def change
    create_table :commentaries do |t|
      t.integer :author_id
      t.text :content
      t.datetime :create_at

      t.timestamps
    end
  end
end
