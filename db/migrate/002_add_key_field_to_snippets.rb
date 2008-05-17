class AddKeyFieldToSnippets < ActiveRecord::Migration
  def self.up
    add_column :snippets, :key, :string
  end

  def self.down
    remove_column :snippets, :key
  end
end
