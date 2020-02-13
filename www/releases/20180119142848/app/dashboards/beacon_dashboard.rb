class BeaconDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,

    beacon_id: Field::String.with_options(searchable: true),
    battery_life: Field::Number,
    battery_life_updated_at: Field::DateTime,
    ibeacon_uuid: Field::String.with_options(searchable: true),
    ibeacon_major: Field::Number,
    ibeacon_minor: Field::Number,

    corner: Field::BelongsTo,

    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[id beacon_id battery_life corner].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id

    beacon_id
    battery_life
    battery_life_updated_at
    ibeacon_uuid
    ibeacon_major
    ibeacon_minor

    corner

    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    beacon_id
    ibeacon_uuid
    ibeacon_major
    ibeacon_minor

    corner
  ].freeze

  def display_resource(beacon)
    "Beacon #{beacon.beacon_id}"
  end
end
