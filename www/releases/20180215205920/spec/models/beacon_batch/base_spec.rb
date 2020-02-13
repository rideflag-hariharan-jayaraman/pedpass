describe BeaconBatch::Base do
  describe '#process' do
    before do
      @generator = DetectedBeaconGenerator.new
    end

    it 'should create a detected_corner' do
      batch = BeaconBatch::Base.new(@generator.parsed_data)

      expect(batch.process).to be_valid
      expect do
        batch.process
      end.to change{DetectedCorner.count}.by(1)
    end

    it 'should create detected_beacons(s)' do
      batch = BeaconBatch::Base.new(@generator.parsed_data)

      expect do
        batch.process
      end.to change{DetectedBeacon.count}.by(batch.data.beacon_data.count)
    end

    it 'should return an invalid detected corner for invalid or no data' do
      batch = BeaconBatch::Base.new(@generator.parsed_data.merge({
        detected_beacons: @generator.unregistered_others
      }))

      detected_corner = batch.process

      expect(batch.data.beacon_data).to be_empty
      expect(detected_corner.valid?).to be false
    end
  end
end
