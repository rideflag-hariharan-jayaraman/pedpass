module BeaconBatch
  module Strategies
    class Smallest < Strategy
      def calcuate
        closest_entry = smallest_average_beacon_subset.reduce do |closest, data|
          if closest.present? &&
              closest.raw[:beacon_distance] < data.raw[:beacon_distance]
            closest
          else
            data
          end
        end

        if closest_entry.present?
          {
            corner: closest_entry.beacon.corner,
            beacon_distance: closest_entry.raw[:beacon_distance],
            beacon_proximity: closest_entry.raw[:beacon_proximity]
          }
        else
          {}
        end
      end
    end
  end
end
