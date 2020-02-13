class Profile < ApplicationRecord
  include ClassyEnum::ActiveRecord

  belongs_to :user

  classy_enum_attr :age_range
  classy_enum_attr :gender

  validates :age_range, :gender, presence: true
end
