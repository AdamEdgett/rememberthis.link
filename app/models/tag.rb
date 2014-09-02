class Tag < ActiveRecord::Base
  self.primary_key = :id
  attr_accessible :id, :text, :user
  has_and_belongs_to_many :links
  belongs_to :user, dependent: :destroy

  validates_presence_of :text,
    :message => "Tag must have text"
  validates_presence_of :user,
    :message => "Tag must have a user"
end
