class UserSerializer < ApplicationSerializer
  attributes :email

  has_one :profile
  has_many :devices
end
