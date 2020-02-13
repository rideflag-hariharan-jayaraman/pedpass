class CrossingSerializer < ApplicationSerializer
  attributes :success, :message

  has_one :crosswalk
  has_one :user

  def message
    object.message&.text
  end
end
