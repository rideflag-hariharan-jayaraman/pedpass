require "administrate/base_dashboard"

class CrossingFailureReasonDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    description: Field::String,
    failure_reason: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :description,
    :failure_reason,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :description,
    :failure_reason,
  ].freeze

  FORM_ATTRIBUTES = [
    :description,
    :failure_reason,
  ].freeze

  def display_resource(crossing_failure_reason)
    "#{crossing_failure_reason.to_s}"
  end
end
