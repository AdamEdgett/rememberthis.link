class Link < ActiveRecord::Base
  self.primary_key = :id
  attr_accessible :id, :title, :url, :created_at, :updated_at, :user, :tags
  has_and_belongs_to_many :tags
  belongs_to :user, dependent: :destroy

  validates_presence_of :url,
    :message => "Link must have a URL"
  validates_presence_of :user,
    :message => "Link must have a user"

  before_save :add_protocol

  private
  def add_protocol
    if !url.start_with?("http")
      self.url = url.prepend("http://")
    end
  end
end
