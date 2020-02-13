describe User do
  it { should have_many :devices }
  it { should have_many :crossings }
end
