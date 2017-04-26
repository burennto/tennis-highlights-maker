class VideoEnhancer

  TITLE_OVERLAY_POSITION = 'overlay=main_w-overlay_w-20:20'
  SCORE_OVERLAY_POSITION = 'overlay=20:main_h-overlay_h-20'
  STATS_OVERLAY_POSITION = 'overlay=main_w/2-overlay_w/2:main_h/2-overlay_h/2'

  TITLE_DURATION = 7
  LAST_POINT_DURATION = 7

  def self.add_overlays(points, title_duration)
    inputs = ''
    filters = ''

    inputs_array = [
      "-i ./tmp/raw/match.mp4",
      "-i ./tmp/overlays/title.png",
    ]

    points.each_with_index do |point, i|
      next if point.win_type == 'SKIPPED'
      inputs_array << "-i ./tmp/overlays/#{i}.png"
    end

    last_overlay = points.length
    inputs_array << "-i ./tmp/overlays/#{last_overlay}.png"

    points.select! { |p| p.win_type != 'SKIPPED' }

    first_point_start  = TimeUtil.timestamp_to_seconds( points[0].start )
    first_point_finish = TimeUtil.timestamp_to_seconds( points[0].finish )

    filters_array = [
      "[0:v][1:v] #{TITLE_OVERLAY_POSITION}:enable='between(t,0,#{TITLE_DURATION})' [tmp]",
      "[tmp][2:v] #{SCORE_OVERLAY_POSITION}:enable='between(t,#{TITLE_DURATION+3},#{first_point_finish})' [tmp]"
    ]

    points.each_with_index do |point, i|
      start = TimeUtil.timestamp_to_seconds( point.finish )
      finish = nil

      # next_point = i+1 < points.count ? points[i+1] : nil
      next_point = points[i+1]

      if next_point
        finish = TimeUtil.timestamp_to_seconds( next_point.finish )
      else
        finish = TimeUtil.timestamp_to_seconds( point.finish ) + LAST_POINT_DURATION
      end

      duration = "enable='between(t,#{start},#{finish})'"

      filter = "[tmp][#{i+3}:v] #{SCORE_OVERLAY_POSITION}:#{duration} [tmp]"
      filters_array << filter
    end

    inputs_array << "-i ./tmp/overlays/stats.png"

    last_point_finish = TimeUtil.timestamp_to_seconds( points.last.finish )
    stats_start = last_point_finish + LAST_POINT_DURATION

    duration = "enable='between(t,#{stats_start},#{3*60*60})'"
    filters_array << "[tmp][#{points.count+3}:v] #{STATS_OVERLAY_POSITION}:#{duration}"

    inputs = inputs_array.join(' ')
    filters = filters_array.join('; ')

    # puts inputs_array
    # puts filters_array

    outfile = './tmp/raw/match-with-overlays.mp4'

    `ffmpeg -y #{inputs} -filter_complex "#{filters}" #{outfile}`
  end

end
