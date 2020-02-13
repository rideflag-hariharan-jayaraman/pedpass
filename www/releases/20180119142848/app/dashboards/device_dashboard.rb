class DeviceDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    uuid: Field::String,
    detected_corners: Field::HasMany,
    user: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[id user created_at].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    user
    detected_corners
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[user].freeze

  def display_resource(device)
    "Device #{device.uuid.last(4)}"
  end
end
