describe DetectedCornerFilter do
  describe '#uniq_filtered_set' do
    before do
      corner1 = create(:corner)
      corner2 = create(:corner)
      @data = []

      @data.concat create_list(:detected_corner, 5, corner: corner1)
      @data << create(:detected_corner, corner: corner1, beacon_distance: 0.12)
      @data.concat create_list(:detected_corner, 5, corner: corner2)
      @data << create(:detected_corner, corner: corner2, beacon_distance: 0.12)
    end

    it 'returns 1 detected_corner for each corner with smallest distance' do
      result = DetectedCornerFilter.new(@data).uniq_filtered_set

      expect(result.count).to eq 2
      expect(result.first.beacon_distance).to  eq 0.12
    end
  end
end
