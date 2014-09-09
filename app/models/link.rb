# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  url        :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Represents a link
class Link < ActiveRecord::Base
  self.primary_key = :id
  attr_accessible :id, :title, :url, :created_at, :updated_at, :user, :tags
  has_and_belongs_to_many :tags
  belongs_to :user, dependent: :destroy

  validates_presence_of :url, message: 'Link must have a URL'
  validates_presence_of :user, message: 'Link must have a user'

  before_save :add_protocol

  private

  def add_protocol
    self.url = url.prepend('http://') unless url.start_with?('http')
  end
end
