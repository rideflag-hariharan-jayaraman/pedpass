describe ApplicationRecord do
  subject { described_class }

  its(:abstract_class) { should eql true }
end
