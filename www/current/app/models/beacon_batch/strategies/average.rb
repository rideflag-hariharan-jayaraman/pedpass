module BeaconBatch
  module Strategies
    class Average < Strategy
      def calcuate
        beacon_subset = smallest_average_beacon_subset
        return {} if beacon_subset.empty?

        calculated_distance = set_average(beacon_subset)
        {
          corner: beacon_subset.first.beacon.corner,
          beacon_distance: calculated_distance,
          beacon_proximity: beacon_proximity(calculated_distance)
        }
      end

      private
      def beacon_proximity(distance)
        if distance < 0.5
          "IMMEDIATE"
        elsif distance < 2
          "NEAR"
        else
          "FAR"
        end
      end
    end
  end
end
