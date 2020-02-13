# The be-all-end-all {User} model. All hail the mighty user.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :crossings
  has_many :redemptions
  has_many :devices
  has_many :identities
  has_one :profile

  validates :email, presence: true, uniqueness: true

  accepts_nested_attributes_for :devices, :profile

  def recover_password
    self.set_reset_password_token
  end


  # for rails_admin
  def name
    "#{id} - #{email}"
  end

  def points
    UserPoints.new(self).total_points
  end
end
