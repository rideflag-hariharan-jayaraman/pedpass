describe Beacon do
  it { should belong_to :corner }
  it { should belong_to :ibeacon_uuid }

  # describe '#'

  describe '#beacon_id' do
    it 'should be a unique combined value of ibeacon_major & ibeacon_minor' do

    end

    it 'should be uneditable'
  end


end
