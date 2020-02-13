class Redemption < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  validates :quantity, :points, presence: true
end
