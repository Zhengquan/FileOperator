class AddDescriptionToPainting < ActiveRecord::Migration
  def self.up
    add_column :paintings, :description, :text
  end

  def self.down
    remove_column :paintings, :description
  end
end
