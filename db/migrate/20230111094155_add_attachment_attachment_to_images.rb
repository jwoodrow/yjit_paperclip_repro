class AddAttachmentAttachmentToImages < ActiveRecord::Migration[7.0]
  def self.up
    change_table :images do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :images, :attachment
  end
end
