class Function < ActiveRecord::Base
  belongs_to :category
  belongs_to :language

  validates_presence_of :name, :documentation, :category_id, :language_id
end
