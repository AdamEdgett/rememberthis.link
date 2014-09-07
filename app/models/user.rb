require 'bcrypt'
class User < ActiveRecord::Base
  self.primary_key = :id
  attr_accessible :id, :email, :password, :password_confirmation
  attr_accessor :password_confirmation

  has_many :links
  has_many :tags

  validates_uniqueness_of :email,
    :message => "Email address has already been used",
    :case_sensitive => false
  validates_confirmation_of :password,
    :if => :password_changed?,
    :message => "Passwords did not match"

  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :on => :create,
    :message => "Invalid email address"

  before_save :hash_new_password, :if=>:password_changed?
  before_save :downcase_email

  def self.authenticate(email, password)
    if user = find_by_email(email)
      if BCrypt::Password.new(user.password).is_password? password
        return user
      end
    end
  end

  def self.find_by_email(email)
    find_by(email: email.downcase)
  end

  private
  def password_changed?
    !password_confirmation.blank?
  end

  def hash_new_password
    self.password = BCrypt::Password.create(password)
  end

  def downcase_email
    self.email = email.downcase
  end

end
