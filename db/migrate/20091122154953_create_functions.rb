class CreateFunctions < ActiveRecord::Migration
  def self.up
    create_table :functions do |t|
      t.string :name
      t.string :arguments
      t.string :result
      t.text :documentation
      t.references :category
      t.references :language

      t.timestamps
    end
  end

  def self.down
    drop_table :functions
  end
end
