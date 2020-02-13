describe DetectedBeacon do
  it { should belong_to :detected_corner }
  it { should belong_to :beacon }

  describe 'callbacks' do
    let(:beacon) { create(:beacon, battery_life_updated_at: DateTime.current - 5.days) }

    it 'should update battery_life of beacon after creation' do
      detected_beacon = build(:detected_beacon, beacon: beacon, beacon_battery: 50)

      expect{detected_beacon.save}.to change(detected_beacon.beacon, :battery_life_updated_at)
      expect(detected_beacon.beacon.battery_life).to eql(50)
    end
  end
end
