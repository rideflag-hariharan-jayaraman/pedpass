describe BeaconBatch::Data do
  before do
    @generator = DetectedBeaconGenerator.new
  end

  # describe '#beacon_data' do
  #   it 'should remove unregisterd beacons' do
  #     subject { BeaconBatch::Data.new(@generate.parsed_data) }
  #   end
  #   it 'should remove beacons' do
  #     data = BeaconBatch::Base.new(@generator.parsed_data)
  #
  #     expect(batch.process).to be_valid
  #     expect do
  #       batch.process
  #     end.to change{DetectedCorner.count}.by(1)
  #   end
  #
  #   it 'should create detected_beacons(s)' do
  #     batch = BeaconBatch::Base.new(@generator.parsed_data)
  #
  #     expect do
  #       batch.process
  #     end.to change{DetectedBeacon.count}.by(batch.data[:detected_beacons].count)
  #   end
  # end
end
