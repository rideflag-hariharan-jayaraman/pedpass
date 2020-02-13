describe UserPoints do
  let(:user) { create(:user) }
  let(:crosswalk) { create(:crosswalk_with_corners) }

  describe '#award_points' do
    context 'no past crossing on intersection' do
      it 'rewards a single point' do
        points = UserPoints.new user

        expect(points.award_points crosswalk).to eq 1
      end
    end

    context 'crossed same intersection half hour before' do
      before do
        create(:crossing, user: user, crosswalk: crosswalk, success: true, points_earned: 1)
      end
      it 'rewards no points' do
        points = UserPoints.new user

        expect(points.award_points crosswalk).to eq 0
      end
    end

    context 'crossed same intersection 6 hrs ago' do
      before do
        create(:crossing, {
          user: user, crosswalk: crosswalk,
          success: true, points_earned: 1,
          created_at: 6.hours.ago
        })
      end

      it 'rewards 1 point' do
        points = UserPoints.new user

        expect(points.award_points crosswalk).to eq 1
      end
    end

  end
end
