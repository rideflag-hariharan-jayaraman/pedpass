class CornerDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,

    location_in_intersection: Field::String.with_options(searchable: true),
    latitude: Field::Number,
    longitude: Field::Number,

    crosswalks: Field::HasMany,
    devices: Field::HasMany,
    beacon: Field::HasOne,
    intersection: Field::BelongsTo,

    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    location_in_intersection
    crosswalks
    beacon
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id

    intersection
    location_in_intersection
    latitude
    longitude

    beacon
    crosswalks

    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    intersection
    location_in_intersection
    latitude
    longitude
  ].freeze

  def display_resource(corner)
    "#{corner.location_in_intersection} Corner"
  end
end
