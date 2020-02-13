class DetectedCornerFilter
  attr_reader :detected_corners

  def initialize(dcs)
    @detected_corners = dcs
  end

  def uniq_filtered_set
     outcome = partion_by_corner(
       detected_corners.each_with_index.select do |dc, i|
         if i == 0 || i === detected_corners.size - 1
           true
         else
           corner_id = dc.corner_id
           if corner_id == detected_corners[i-1].corner_id ||
             corner_id == detected_corners[i+1].corner_id
             true
           else
             false
           end
         end
       end.map { |d| d[0] }
     ).values.map do |p|
       p.min { |a, b| a.beacon_distance <=> b.beacon_distance }
     end

     outcome
  end

  private
  def partion_by_corner(data)
    data.reduce({}) do |aggr, dc|
      aggr[dc.corner_id] ||= []
      aggr[dc.corner_id] << dc

      aggr
    end
  end
end
