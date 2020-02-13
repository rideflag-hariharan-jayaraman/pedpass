# A join table between a {Corner} and a {Crosswalk}. It denotes which {Corner}s
# make up the path of a {Crosswalk}.
class Node < ApplicationRecord
  belongs_to :corner
  belongs_to :crosswalk
end
