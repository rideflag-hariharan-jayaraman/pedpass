class DeviceSerializer < ApplicationSerializer
  attributes :api_key

  has_one :user
end
