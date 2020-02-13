describe Corner do
  it { should have_many :nodes }
  it { should have_many(:crosswalks).through :nodes }

  it { should have_many :detected_corners }
  it { should have_many(:devices).through :detected_corners }

  describe 'validations' do
    let(:corner) { create(:corner) }

    context 'near limit above approaching limit' do
      it 'should be invalid' do
        corner.near_limit = 10
        corner.approaching_limit = 5

        expect(corner.valid?).to be false
        expect(corner.errors.has_key? :near_limit).to be true
      end
    end
  end

end
