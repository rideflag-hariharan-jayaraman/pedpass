module BeaconBatch
  # Strategies contain the strategies used to process the beacon batch data to
  # determine the corner the beacon batch data is for and calcuate/select a reasonable
  # beacon distance
  module Strategies
    # Strategy is the base the class that all strategies extend off of
    class Strategy
      def initialize(raw_beacons = [])
        @list = raw_beacons
      end

      # @abstract Subclass is expected to implement #calcuate
      # @!method calcuate
      # The calcuate method executes the strategy and returns a hash containing the
      # corner and beacon distance data

      private
      # It is responsible for filtering beacon data to a specific corners.
      # It uses the algorithm of partioning beacon data by corner and return subset
      # with the lowest average beacon_distance
      def smallest_average_beacon_subset
        partitioned_beacons = @list.reduce({}) do |corners, data|
          corner_id = data.beacon.corner_id
          corners[corner_id] ||=  []
          corners[corner_id] << data

          corners
        end

        if partitioned_beacons.empty?
          []
        else
          partitioned_beacons.values.reduce do |closest, partition|
            set_average(partition) < set_average(closest) ? partition : closest
          end
        end
      end

      def set_average(beacons)
        beacons.map { |b| b.raw[:beacon_distance] }.reduce(:+).to_f / beacons.size
      end
    end
  end
end
