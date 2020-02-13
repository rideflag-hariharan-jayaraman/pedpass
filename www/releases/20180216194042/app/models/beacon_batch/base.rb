## BeaconBatch module is responsible for processing raw beacon data where it
## uses the raw beacon data to generate a detected corner
module BeaconBatch
  # Base represents the base of the batch operation and is the front man for the
  # operation
  class Base
    attr_reader :data

    def initialize(data = {})
      @data = BeaconBatch::Data.new data
      @strategy = Setting.detected_corner_strategy
    end

    def process
      detected = DetectedCorner.new

      beacon_info = if @strategy.downcase == 'average'
        BeaconBatch::Strategies::Average.new(data.beacon_data).calcuate
      else
        BeaconBatch::Strategies::Smallest.new(data.beacon_data).calcuate
      end

      detected_corner_params = data.corner_data.merge(beacon_info)
      detected.assign_attributes(detected_corner_params)

      data.detected_beacon_data.each do |params|
        detected.detected_beacons.new params
      end

      detected.save
      detected
    end
  end
end
