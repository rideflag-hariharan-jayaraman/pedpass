describe BeaconBatch::Strategies::Average do
  describe '#calculate' do
    before do
      @generator = DetectedBeaconGenerator.new
      @data = BeaconBatch::Data.new(@generator.parsed_data).beacon_data
    end

    it 'should return the beacon with the average distance' do
      outcome = BeaconBatch::Strategies::Average.new(@data).calcuate
      # subset = @generator.immediates
      # expected_average = subset.map { |b| b[:beacon_distance] }.reduce(:+).to_f / subset.size

      expect(outcome[:corner]).to eql(@generator.start)
    end
  end
end
