require 'fileutils'
require 'csv'
require 'awesome_print'

require_relative './tennis/team'
require_relative './tennis/player'
require_relative './tennis/match'
require_relative './tennis/set'
require_relative './tennis/game'
require_relative './tennis/point'
require_relative './tennis/stats'
require_relative './tennis/score'

require_relative './video/video'
require_relative './video/video_editor'
require_relative './video/video_enhancer'

require_relative './util/match_loader'
require_relative './util/match_snapshot'
require_relative './util/time_util'

require_relative './overlay/title_overlay'
require_relative './overlay/stats_overlay'

class HighlightsMaker

  def initialize(title:, date:, p1:, p2:, csv_path:, video_path:, title_duration:)
    @title = title
    @date = date

    @title_duration = title_duration

    @p1, @p2 = p1, p2

    @csv_path = csv_path

    @match = Match.new
    @stats = Stats.new(@match)
  end

  def run
    init_tmp_dirs

    check_points
    load_points

    create_title_overlay
    create_stat_overlays
    create_score_overlays

    add_overlays_to_video
    chunk_and_concat_video
  end

  private

  def init_tmp_dirs
    FileUtils.mkdir_p('./tmp/raw')
    FileUtils.mkdir_p('./tmp/overlays')
    FileUtils.mkdir_p('./tmp/chunks')
    FileUtils.mkdir_p('./out')
  end

  def check_points
  end

  def load_points
    MatchLoader.new(@match).load_csv(@csv_path)
    puts @match
    puts @stats
  end

  def create_title_overlay
    TitleOverlay.new(
      title: @title,
      date: @date
    ).to_png('./tmp/overlays/title.png');
  end

  def create_stat_overlays
    StatsOverlay.new(
      p1: @p1,
      p2: @p2,
      stats: @stats,
      title: @title,
      date: @date,
    ).to_png('./tmp/overlays/stats.png')
  end

  def create_score_overlays
    snapshot = MatchSnapshot.new
    ScoreOverlay.new(snapshot, @p1, @p2).to_png

    @match.points.each_with_index do |point, i|
      points = @match.points.slice(0..i)
      snapshot = MatchSnapshot.new(points)
      ScoreOverlay.new(snapshot, @p1, @p2).to_png
    end
  end

  def add_overlays_to_video
    VideoEnhancer.add_overlays(@match.points, @title_duration)
  end

  def chunk_and_concat_video
    source = './tmp/raw/match-with-overlays.mp4'
    VideoEditor.chunk_and_concat(source, @match.points, @title_duration)
  end

end
