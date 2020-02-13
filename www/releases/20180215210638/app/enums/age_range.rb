class AgeRange < ClassyEnum::Base

  def self.sample
    self.to_a.sample
  end

  def self.get_from_age(age)
    self.find do |range|
      split = range.to_s.gsub(/[ft]/, ' ').split.map(&:to_i)
      age >= split[0] && age <= split[1]
    end
  end
end

class AgeRange::F15T19 < AgeRange
  def to_s
    'f15t19'
  end

  def text
    '15-19'
  end
end

class AgeRange::F20T24 < AgeRange
  def to_s
    'f20t24'
  end

  def text
    '20-24'
  end
end

class AgeRange::F25T29 < AgeRange
  def to_s
    'f25t29'
  end

  def text
    '25-29'
  end
end

class AgeRange::F30T34 < AgeRange
  def to_s
    'f30t34'
  end

  def text
    '30-34'
  end
end

class AgeRange::F35T39 < AgeRange
  def to_s
    'f35t39'
  end

  def text
    '35-39'
  end
end

class AgeRange::F40T44 < AgeRange
  def to_s
    'f40t44'
  end

  def text
    '40-44'
  end
end

class AgeRange::F45T49 < AgeRange
  def to_s
    'f45t49'
  end

  def text
    '45-49'
  end
end

class AgeRange::F50T54 < AgeRange
  def to_s
    'f50t54'
  end

  def text
    '50-54'
  end
end

class AgeRange::F55T59 < AgeRange
  def to_s
    'f55t59'
  end

  def text
    '55-59'
  end
end

class AgeRange::F60T64 < AgeRange
  def to_s
    'f60t64'
  end

  def text
    '60-64'
  end
end

class AgeRange::F65T69 < AgeRange
  def to_s
    'f65t69'
  end

  def text
    '65-69'
  end
end
