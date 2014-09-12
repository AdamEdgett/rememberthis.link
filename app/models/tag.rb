# == Schema Information
#
# Table name: tags
#
#  id      :integer          not null, primary key
#  text    :string(255)
#  user_id :integer
#
# Represents a tag
class Tag < ActiveRecord::Base
  self.primary_key = :id
  attr_accessible :id, :text, :user
  has_and_belongs_to_many :links
  belongs_to :user

  validates_presence_of :text, message: 'Tag must have text'
  validates_presence_of :user, message: 'Tag must have a user'

  validates_uniqueness_of :text, scope: :user,
    message: 'Cannot have duplicate tag',
    case_sensitive: false
end
