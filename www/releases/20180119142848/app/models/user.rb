# The be-all-end-all {User} model. All hail the mighty user.
class User < ApplicationRecord
  has_many :crossings
  has_many :devices

  accepts_nested_attributes_for :devices
end
