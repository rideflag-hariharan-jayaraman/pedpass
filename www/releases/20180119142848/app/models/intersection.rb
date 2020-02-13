class Intersection < ApplicationRecord
  has_many :corners

  def to_s
    name
  end
end
