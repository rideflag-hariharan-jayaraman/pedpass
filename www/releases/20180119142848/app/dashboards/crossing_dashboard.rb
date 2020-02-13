class CrossingDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    detected_corners: Field::HasMany,
    crosswalk: Field::BelongsTo,
    success: Field::Boolean,
    crossing_failure_reason: Field::BelongsTo,
    user: Field::BelongsTo,
    sub_user_id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    user
    sub_user_id
    detected_corners
    crosswalk
    success
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    user
    sub_user_id
    crosswalk
    success
    crossing_failure_reason
    detected_corners
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[detected_corners].freeze
end
