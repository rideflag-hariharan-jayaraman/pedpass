describe Crossing do
  it { should have_many :detected_nodes }
  it { should have_many(:detected_corners).through :detected_nodes }

  it { should belong_to :crosswalk }
  it { should belong_to :user }
end
