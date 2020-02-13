class DetectedCornerDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    crossings: Field::HasMany,
    device: Field::BelongsTo,
    sub_user_id: Field::Number,
    corner: Field::BelongsTo,
    id: Field::Number,
    processed: Field::Boolean,
    beacon_proximity: Field::String,
    beacon_distance: Field::Number,
    latitude: Field::Number,
    longitude: Field::Number,
    accuracy: Field::Number,
    heading: Field::Number,
    speed: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[device sub_user_id corner beacon_distance processed].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    device
    sub_user_id
    corner
    beacon_distance
    latitude
    longitude
    accuracy
    heading
    speed
    processed
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[device corner crossings].freeze
end
