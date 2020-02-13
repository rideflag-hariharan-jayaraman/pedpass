class UserDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    devices: Field::HasMany,
    crossings: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[id devices crossings created_at].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    devices
    crossings
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[devices].freeze
end
