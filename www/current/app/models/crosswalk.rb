# A registered crosswalk that has at leat two {Corner}s denoting its path in
# space.
class Crosswalk < ApplicationRecord
  has_many :nodes
  has_many :corners, through: :nodes

  has_many :crossings

  # Returns a Crosswalk object
  def self.with_corners(corner_ids)
    # node_counts is a hash {1=>2, 2=>1, 3=>1} representing (CROSSWALK.ID, Number of corners from the array corner_ids)
    node_counts = Crosswalk.joins(:nodes).where("corner_id in (?)", corner_ids).group('crosswalk_id').count

    # select the crosswalk that contains all corners the corners_ids
    includes(:nodes).find(node_counts.keys).to_a.find do |crosswalk|
      crosswalk.nodes.size == node_counts[crosswalk.id]
    end
  end
end
