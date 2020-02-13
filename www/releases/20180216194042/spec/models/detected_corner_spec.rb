describe DetectedCorner do
  it { should have_many :detected_nodes }
  it { should have_many(:crossings).through :detected_nodes }

  it { should belong_to :device }
  it { should belong_to :corner }

  it { should have_many(:nodes).through :corner }

  describe '#detect_crosswalk' do
    let(:device) { create :device }
    let(:bad_device) { create :device }
    let(:corner_1) { create :corner }
    let(:corner_2) { create :corner }
    let(:bad_corner) { create :corner }
    let!(:crosswalk) { create :crosswalk, corners: [corner_1, corner_2] }
    let!(:bad_crosswalk) { create :crosswalk, corners: [bad_corner, corner_2] }

    context 'when there are two corners on a crosswalk' do
      it 'will identify a crossing' do
        # create :detected_corner, corner: bad_corner, device: device,
        #   created_at: 1.day.ago
        #
        # first_detection = create :detected_corner, corner: corner_1,
        #                     device: device, created_at: 20.seconds.ago
        #
        # create :detected_corner, corner: corner_1, device: bad_device,
        #   created_at: 20.seconds.ago
        #
        # second_detection = create :detected_corner, corner: corner_2,
        #                      device: device, created_at: 5.seconds.ago
        #
        # expect(first_detection.detect_crosswalk).to be_nil
        # expect(second_detection.detect_crosswalk).to eql crosswalk
      end
    end
  end

  describe '#near_corner?' do
    subject { create(:detected_corner) }

    context 'corner present' do
      it 'should be true if distance is less than near limit' do
        subject.corner.near_limit = 5
        subject.beacon_distance = 3

        expect(subject.near_corner?).to be true
      end
    end

    context 'corner missing' do
      it 'should be false' do
        subject.corner = nil
        expect(subject.near_corner?).to be false
      end
    end
  end

  describe '#approaching_corner?' do
    subject { create(:detected_corner) }

    context 'corner present' do
      it 'should be true if distance is less than approaching limit' do
        subject.corner.approaching_limit = 10
        subject.beacon_distance = 8

        expect(subject.approaching_corner?).to be true
      end
    end

    context 'corner missing' do
      it 'should be false' do
        subject.corner = nil
        expect(subject.approaching_corner?).to be false
      end
    end
  end
end
