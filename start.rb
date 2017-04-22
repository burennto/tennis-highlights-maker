require_relative './src/highlights_maker'

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

maker = HighlightsMaker.new(
  title: TITLE,
  date: DATE,
  p1: TEAMS[0],
  p2: TEAMS[1],
  csv_path: CSV_PATH,
)

maker.run





# # match_video = VideoEditor.trim_and_concat(SOURCES)
