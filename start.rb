require_relative './src/highlights_maker'

TITLE = 'Melbourne Park Social A Grade (Round 3)'
DATE  = '16 February, 2017'

PLAYERS = [
  Player.new('Jun', 'JUN'),
  Player.new('Brent', 'BRENT'),
  Player.new('Solomon', 'SOLOMON'),
  Player.new('Nigel', 'NIGEL'),
]

TEAMS = [
  Team.new(PLAYERS[0], PLAYERS[1], 'BRENT'),
  Team.new(PLAYERS[2], PLAYERS[3], 'NIGEL'),
]

# CSV_PATH = File.expand_path '~/Tennis/scores/2017-02-23-round-3-doubles.csv'
# CSV_PATH = File.expand_path '~/Tennis/scores/2017-03-16-round-6-jun-vs-danijel.csv'
CSV_PATH = File.expand_path '~/Tennis/scores/2017-02-23-round-3-singles-1-brent-vs-nigel.csv'

VIDEO_PATH = './tmp/raw/match.mp4'

# ======================================================================

options = {
  title: TITLE,
  date: DATE,
  csv_path: CSV_PATH,
  video_path: VIDEO_PATH,
  p1: TEAMS[0],
  p2: TEAMS[1],
  title_duration: { start: '0:00:00', finish: '0:00:07' }
}

HighlightsMaker.new(options).run
