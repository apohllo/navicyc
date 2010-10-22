class Language < ActiveRecord::Base
  validates_presence_of :name, :description, :url
  has_many :categories
  has_many :functions
end
