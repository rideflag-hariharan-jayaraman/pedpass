describe Corner do
  it { should have_many :nodes }
  it { should have_many(:crosswalks).through :nodes }

  it { should have_many :detected_corners }
  it { should have_many(:devices).through :detected_corners }
end
