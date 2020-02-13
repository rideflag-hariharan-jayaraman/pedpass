class Gender < ClassyEnum::Base
  def self.sample
    self.to_a.sample
  end
end

class Gender::M < Gender
end

class Gender::F < Gender
end

class Gender::O < Gender
end
