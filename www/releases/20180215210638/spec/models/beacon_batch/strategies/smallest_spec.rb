describe BeaconBatch::Strategies::Smallest do
  describe '#calculate' do
    before do
      @generator = DetectedBeaconGenerator.new
      @data = BeaconBatch::Data.new(@generator.parsed_data).beacon_data
    end

    it 'should return the beacon with the lowest distance' do
      outcome = BeaconBatch::Strategies::Smallest.new(@data).calcuate

      closest = @generator.immediates.reduce do |smallest, data|
        if smallest.nil? || smallest[:beacon_distance] > data[:beacon_distance]
          data
        else
          smallest
        end
      end

      expect(outcome[:corner]).to eql(@generator.start)
      expect(outcome[:beacon_distance]).to eql(closest[:beacon_distance])
    end
  end
end
