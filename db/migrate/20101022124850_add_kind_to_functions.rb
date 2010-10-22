class AddKindToFunctions < ActiveRecord::Migration
  def self.up
    add_column :functions, :kind, :string
  end

  def self.down
    remove_column :functions, :kind
  end
end
