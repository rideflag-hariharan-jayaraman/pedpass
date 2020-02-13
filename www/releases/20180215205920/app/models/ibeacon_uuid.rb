class IbeaconUuid < ApplicationRecord

  # NOTE: used for rails admin
  def name
    to_s
  end

  def to_s
    uuid
  end
end
