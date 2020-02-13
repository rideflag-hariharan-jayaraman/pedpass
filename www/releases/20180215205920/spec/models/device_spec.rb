describe Device do
  it { should have_many :detected_corners }
  it { should have_many(:corners).through :detected_corners }
  it { should belong_to :user }

  it { should validate_presence_of(:uuid) }
  it { should validate_presence_of(:user) }

  describe 'uuid uniqueness limited to user' do
    subject { create(:device) }
    context 'same user, same uuid' do
      it 'should be invalid' do
        device = build(:device, user: subject.user, uuid: subject.uuid)
        device.save

        expect(device.valid?).to be false
        expect(device.errors.has_key?(:uuid)).to be true
      end
    end

    context 'same user, different uuid' do
      it 'should be valid' do
        device = build(:device, user: subject.user, uuid: 'random_string')
        device.save

        expect(device.persisted?).to be true
        expect(device.valid?).to be true
      end
    end

    context 'diff user, same uuid' do
      it 'should be valid' do
        device = build(:device, user: create(:user), uuid: subject.uuid)
        device.save

        expect(device.persisted?).to be true
        expect(device.valid?).to be true
      end
    end
  end
end
