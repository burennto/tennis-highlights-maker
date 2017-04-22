class TimeUtil

  def self.timestamp_to_seconds(timestamp)
    hours, minutes, seconds = timestamp.split(':').map(&:to_i)
    hours * 3600 + minutes * 60 + seconds
  end

end
