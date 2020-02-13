# The hardware that is placed at a street intersection to detect users.
class Corner < ApplicationRecord
  acts_as_mappable :default_units => :kms,
                   :default_formula => :flat,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  belongs_to :intersection

  has_many :nodes
  has_many :crosswalks, through: :nodes

  has_many :detected_corners
  has_many :devices, through: :detected_corners

  has_many :beacons

  validates :latitude, :longitude, presence: true
  validates :latitude, uniqueness: {
    scope: :longitude,
    message: 'and longitude are already in use'
  }

  validate :near_limit_lower_than_approaching_limit

  # you'll thank me later...
  alias_attribute :lat, :latitude
  alias_attribute :lng, :longitude
  # you're welcome

  # NOTE: used for rails admin
  def name
    location_in_intersection.present? ? (
      "#{id}-#{location_in_intersection}"
    ) : ("Corner ##{id}")
  end

  private
  def near_limit_lower_than_approaching_limit
    if near_limit > approaching_limit
      errors.add(:near_limit, 'has to be below approaching limit')
    end
  end


end
