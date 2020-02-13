class Reward < ApplicationRecord
  validates :name, :points, presence: true
end
