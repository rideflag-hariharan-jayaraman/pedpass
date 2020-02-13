# A device that has been registered by a user upon downloading a mobile app.
#
# A user interacts with {Crosswalks}s by a {Corner} that they have been detected
# to have encountered.
class Device < ApplicationRecord
  has_many :detected_corners
  has_many :corners, through: :detected_corners

  belongs_to :user

  validates :user, presence: true
  validates :api_key, presence: true, uniqueness: true
  validates :uuid, presence:true, uniqueness: { scope: :user_id }

  before_validation :generate_api_key, only: :create

  private

  def generate_api_key
    self[:api_key] = SecureRandom.uuid
  end
end
