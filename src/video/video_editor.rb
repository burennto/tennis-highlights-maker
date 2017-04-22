class VideoEditor

  def self.trim_and_concat(videos)
    chunks = videos.map.with_index do |video, i|
      start  = TimeUtil.timestamp_to_seconds(video.start)
      finish = TimeUtil.timestamp_to_seconds(video.finish)
      duration = "#{start}:#{finish}"

      filename = "#{i+1}.mp4"
      destination = "./tmp/raw/#{filename}"

      VideoEditor.trim(video.path, duration, destination)
    end

    VideoEditor.concat( chunks.map(&:path) )
  end

  def self.trim(source, duration, destination)
    `MP4Box -splitx #{duration} #{source} -out #{destination}`

    Video.new(destination)
  end

  def self.concat(sources)
    args = sources.map { |source| "-cat #{source}" }.join(' ')
    destination = './tmp/raw/match.mp4'

    `MP4Box #{args} #{destination}`

    Video.new(destination)
  end

end
