class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.column :user_name, :string
      t.column :language, :string
      t.column :description, :string
      t.column :body, :text
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :snippets
  end
end
