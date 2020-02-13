class Message < ClassyEnum::Base
end

class Message::FailFarFar < Message
  def to_s
    'far_far'
  end
end

class Message::FailFarNear < Message
  def to_s
    'far_near'
  end
end

class Message::FailNearFar < Message
  def to_s
    'near_far'
  end
end

class Message::FailInvalidCrosswalk < Message
  def to_s
    'invalid_crosswalk'
  end
end

class Message::Crossing < Message
end

class Message::AlreadyCrossed < Message
end
