require "administrate/base_dashboard"

class SettingDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    thing: Field::Polymorphic,
    id: Field::Number,
    var: Field::String,
    value: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :var,
    :value,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :var,
    :value,
    :updated_at,
  ].freeze

  FORM_ATTRIBUTES = [
    :var,
    :value,
  ].freeze
end
