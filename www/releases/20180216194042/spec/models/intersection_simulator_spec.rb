describe IntersectionSimulator do

  describe '#setup' do
    before do
      @path_for_corner = Rails.root.join('spec','support', 'data', 'corner_simulation.json').to_s
      @simulator = IntersectionSimulator.new @path_for_corner
    end

    it 'should rebuild the intersection, corners, crosswalk' do
      expect(Intersection.count).to eq 0
      expect(Crosswalk.count).to eq 0
      expect(Node.count).to eq 0


      @simulator.setup

      expect(Intersection.count).to eq 1
      expect(Intersection.first.corners.count).to eq 4

      Intersection.first.corners.each do |corner|
        expect(corner.beacons).not_to be_empty
      end

      expect(Crosswalk.count > 0).to be true
      expect(Node.count > 0).to be true
    end
  end

  describe '#evaluate' do
    before do
      @path_for_corner = Rails.root.join('spec','support', 'data', 'corner_simulation.json').to_s
      @path_for_beacon = Rails.root.join('spec','support', 'data', 'beacon_data.json').to_s

      @simulator = IntersectionSimulator.new @path_for_corner
      @simulator.setup
    end

    it 'should build detected_beacon data' do
      outcome = @simulator.evaluate @path_for_beacon

      expect(DetectedCorner.count > 0).to be true
      expect(DetectedBeacon.count > 0).to be true
      expect(outcome.count > 0).to be true
      expect(Crossing.where(success:true).count).to eq 1
      expect(Crossing.where(success:false).count).to eq 1

      expect(outcome.first.success).to be false
      expect(outcome.second.success).to be true
    end
  end
end
