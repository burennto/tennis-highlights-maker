require 'fileutils'
require 'csv'

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

require_relative './util/match_loader'
require_relative './util/time_util'

require_relative './overlay/title_overlay'
require_relative './overlay/stats_overlay'

class HighlightsMaker

  def initialize(title:, date:, p1:, p2:, csv_path:)
    @title = title
    @date = date

    @p1, @p2 = p1, p2
    @csv_path = csv_path

    @match = Match.new(p1, p2)
    @stats = Stats.new(@match)
  end

  def run
    init_tmp_dirs

    check_points
    load_points
    analyze_stats

    create_title_overlay
    create_stat_overlays
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
  end

  def analyze_stats
    @stats.analyze!
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
      stats: @stats,
      title: @title,
      date: @date,
      p1_name: @p1.display_name,
      p2_name: @p2.display_name,
    ).to_png('./tmp/overlays/stats.png')
  end


end
