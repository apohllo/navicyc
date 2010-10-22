class Category < ActiveRecord::Base
  belongs_to :language
  has_many :functions
  acts_as_tree

  validates_presence_of :name, :language_id
end
