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

  def self.chunk_and_concat(source, points, title_chunk)
    `ffmpeg -y -ss #{title_chunk[:start]} -i #{source} -t #{title_chunk[:finish]} ./tmp/chunks/chunk0.mp4`

    points.select! { |p| p.win_type != 'SKIPPED' }

    chunks = points.map.with_index do |point, i|
      start  = TimeUtil::timestamp_to_seconds(point.start)
      finish = TimeUtil::timestamp_to_seconds(point.finish)

      if point.video_finish.to_s.length > 0
        finish = TimeUtil::timestamp_to_seconds(point.video_finish)
      end

      duration = finish - start
      chunk_file = "./tmp/chunks/chunk#{i+1}.mp4"

      `ffmpeg -y -ss #{start} -i #{source} -t #{duration} #{chunk_file}` #unless File.exists?(chunk_file)

      Video.new(chunk_file)
    end

    chunk_0 = Video.new('./tmp/chunks/chunk0.mp4')
    chunks.unshift(chunk_0)

    VideoEditor.concat( chunks.map(&:path), true )
  end

  def self.trim(source, duration, destination)
    `MP4Box -splitx #{duration} #{source} -out #{destination}`

    Video.new(destination)
  end

  def self.concat(sources, final=false)
    args = sources.map { |source| "-cat #{source}" }.join(' ')

    destination = './tmp/raw/match.mp4'
    destination = './tmp/match.mp4' if final

    `MP4Box #{args} #{destination}`

    Video.new(destination)
  end

end
