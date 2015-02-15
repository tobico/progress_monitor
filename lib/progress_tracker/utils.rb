module Utils
  def self.average(items)
    count = items.count
    if count > 0
      sum = items.reduce(:+)
      sum / count
    else
      0
    end
  end
end
