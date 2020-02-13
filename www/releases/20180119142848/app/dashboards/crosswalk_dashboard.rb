class CrosswalkDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    location: Field::String.with_options(searchable: true),
    corners: Field::HasMany,
    crossings: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[id location crossings].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    location
    corners
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[location corners].freeze

  def display_resource(crosswalk)
    crosswalk&.location || ""
  end
end
