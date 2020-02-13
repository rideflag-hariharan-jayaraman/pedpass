class CrosswalkSerializer < ApplicationSerializer
  attributes :location

  has_many :corners
end
