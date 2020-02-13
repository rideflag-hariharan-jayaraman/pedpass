describe User do
  it { should have_many :devices }
  it { should have_many :crossings }
  it { should have_one :profile }
end
