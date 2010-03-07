class AllowPhotoPositionNull < ActiveRecord::Migration
  def self.up
    change_column :photos, :position, :integer, :null => true
  end

  def self.down
    change_column :photos, :position, :integer, :null => false
  end
end
