class AddBookPrefix < ActiveRecord::Migration
  def self.up
      add_column :books, :prefix, :string
  end

  def self.down
      remove_column :books, :prefix
  end
end
