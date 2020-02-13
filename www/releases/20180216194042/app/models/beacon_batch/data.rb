module BeaconBatch
  # It will organize the data for beacon processing
  class Data
    attr_reader :data

    def initialize(data)
      @data = data
    end

    # It provides a cleaned version of the beacon data that goes through the following
    # filters:
    #   - ensure beacon has a uuid registered to the platform
    #   - ensure beacon exists on the platform
    def beacon_data
      @beacon_data ||= (data[:detected_beacons] || []).map do |entry|
        ibeacon_uuid = IbeaconUuid.find_by(uuid: entry[:ibeacon_uuid])

        entry.merge ibeacon_uuid: ibeacon_uuid&.id
      end.map do |entry|
        OpenStruct.new({
          beacon: Beacon.find_by({
            beacon_id: combine_major_minor(entry),
            ibeacon_uuid_id: entry[:ibeacon_uuid]
          }),
          raw: entry
        })
      end.select { |d| d.beacon.present? }
    end

    def corner_data
      data.except(:detected_beacons)
    end

    def detected_beacon_data
      beacon_data.map do |o|
        o.raw.merge(beacon_id: o.beacon.id).except(:ibeacon_major, :ibeacon_minor, :ibeacon_uuid)
      end
    end


    private
    def combine_major_minor(data)
      "#{data[:ibeacon_major]}_#{data[:ibeacon_minor]}"
    end
  end
end
