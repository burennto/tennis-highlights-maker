class TimeUtil

  def self.timestamp_to_seconds(timestamp)
    hours, minutes, seconds = timestamp.split(':').map(&:to_i)
    hours * 3600 + minutes * 60 + seconds
  end

  def self.seconds_to_timestamp(seconds)
    hours, remainder = seconds.divmod(3600)
    minutes, seconds = remainder.divmod(60)

    "#{hours}:#{minutes}"
  end

end
