require 'fileutils'
require 'csv'

require_relative './src/tennis/team'
require_relative './src/tennis/player'
require_relative './src/tennis/match'
require_relative './src/tennis/set'
require_relative './src/tennis/game'
require_relative './src/tennis/point'
require_relative './src/tennis/stats'

require_relative './src/video/video'
require_relative './src/video/video_editor'

require_relative './src/util/match_loader'
require_relative './src/util/time_util'

require_relative './src/overlay/stats_overlay'

FileUtils.mkdir_p('./tmp/raw')
FileUtils.mkdir_p('./tmp/overlays')

# ======================================================================

TITLE = 'Melbourne Park Social A Grade (Round 6)'
DATE  = '16 March, 2017'

PLAYERS = [
  Player.new('Jun', 'JUN'),
  Player.new('Brent', 'BRENT'),
  Player.new('Solomon', 'SOLOMON'),
  Player.new('Nigel', 'NIGEL'),
]

TEAMS = [
  Team.new(PLAYERS[0], PLAYERS[1], 'JUN / BRENT'),
  Team.new(PLAYERS[2], PLAYERS[3], 'SOLOMON / NIGEL'),
]

SOURCES = [
  Video.new('~/Movies/FILE0009.mp4', '0:01:30', '0:03:40'),
  Video.new('~/Movies/FILE0010.mp4', '0:27:00', '0:28:00')
]

CSV_PATH = File.expand_path '~/Documents/tennis_scores/2017-02-23-round-3-doubles.csv'

# ======================================================================

match = Match.new(TEAMS[0], TEAMS[1])
MatchLoader.new(match).load_csv(CSV_PATH)

stats = Stats.new(match)
stats.analyze!

puts match
puts stats

stats_overlay = StatsOverlay.new(
  stats: stats,
  title: TITLE,
  date: DATE,
  p1_name: TEAMS[0].display_name,
  p2_name: TEAMS[1].display_name,
)
stats_overlay.to_png('./tmp/overlays/stats.png')

# match_video = VideoEditor.trim_and_concat(SOURCES)
