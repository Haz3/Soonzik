class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :url
      t.integer :file_size
      t.string :content_type

      t.timestamps
    end
  end
end
