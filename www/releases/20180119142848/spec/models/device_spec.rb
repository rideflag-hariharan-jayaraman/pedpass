describe Device do
  it { should have_many :detected_corners }
  it { should have_many(:corners).through :detected_corners }

  it { should belong_to :user }
end
