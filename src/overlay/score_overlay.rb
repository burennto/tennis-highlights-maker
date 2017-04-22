require 'rmagick'
include Magick

class ScoreOverlay

  IMG_WIDTH  = 380
  IMG_HEIGHT = 91

  FONT_FAMILY = 'helvetica'
  FONT_SIZE = 22
  FONT_COLOR = 'white'

  BG_COLOR = 'black'

  BORDER_WIDTH = 3
  BORDER_COLOR = 'white'
  STROKE_COLOR = 'white'

  PADDING = 14

  def initialize(match)
    filename = "#{match.points.count}.png"
    @destination = File.join('./tmp', 'overlays', filename)

    @img = Image.new(IMG_WIDTH, IMG_HEIGHT) { self.background_color = BG_COLOR }
    @draw = Magick::Draw.new
    @draw.font_family = FONT_FAMILY
    @draw.pointsize = FONT_SIZE
    @draw.fill = FONT_COLOR
    @draw.stroke = BORDER_COLOR
    @draw.stroke_width = BORDER_WIDTH
    @draw.stroke_antialias(false)
    @draw.text_antialias(false)
    @draw.interline_spacing = 0
    @draw.gravity = Magick::WestGravity

    @match = match
    @p1_name = @match.p1.display_name
    @p2_name = @match.p2.display_name

    @p1_games = @match.games.count { |game| game.winner == 1 }
    @p2_games = @match.games.count { |game| game.winner == 2 }

    @p1_points = @match.sets.last.games.last.points.count { |point| point.winner_id == 1 }
    @p2_points = @match.sets.last.games.last.points.count { |point| point.winner_id == 2 }

    @p1_is_serving = (@p1_games + @p2_games) % 2 == 0
    @p2_is_serving = !@p1_is_serving
  end

  def to_png
    draw_borders

    @draw.stroke = 'transparent'
    @draw.stroke_width = 0

    p1_offset_y = (IMG_HEIGHT * -0.25)
    p2_offset_y = (IMG_HEIGHT * 0.25) + 3

    draw_player_name(@p1_name, p1_offset_y, @p1_is_serving)
    draw_player_name(@p2_name, p2_offset_y, @p2_is_serving)

    @draw.gravity = Magick::EastGravity

    @p1_points_pretty = Score.pretty(@p1_points, @p2_points)
    @p2_points_pretty = Score.pretty(@p2_points, @p1_points)

    if @p1_games == 0 && @p2_games == 0
      @p1_games = ''
      @p2_games = ''
    else
      @p1_games = @p1_games.to_s
      @p2_games = @p2_games.to_s
    end

    draw_player_points(@p1_points_pretty, p1_offset_y)
    draw_player_points(@p2_points_pretty, p2_offset_y)

    draw_player_games(@p1_games, p1_offset_y)
    draw_player_games(@p2_games, p2_offset_y)

    @img.write(@destination)
  end

  private

  def draw_borders
    @img.border!(BORDER_WIDTH, BORDER_WIDTH, BORDER_COLOR)
    @draw.line(0, IMG_HEIGHT/2 + BORDER_WIDTH, IMG_WIDTH+BORDER_WIDTH, IMG_HEIGHT/2 + BORDER_WIDTH)

    offset_1 = 70
    offset_2 = 120

    @draw.line(IMG_WIDTH-offset_1, 0, IMG_WIDTH-offset_1, IMG_HEIGHT+BORDER_WIDTH*2)
    @draw.line(IMG_WIDTH-offset_2, 0, IMG_WIDTH-offset_2, IMG_HEIGHT+BORDER_WIDTH*2)
    @draw.draw(@img)
  end

  def first_game?
    @p1_games == 0 && @p2_games == 0
  end

  def set_finished?
    return case
      when @p1_games >= 6 && (@p1_games - @p2_games >= 2) then true
      when @p2_games >= 6 && (@p2_games - @p1_games >= 2) then true
      else false
    end
  end

  def draw_player_name(name, offset_y, is_serving)
    offset_x = PADDING
    @draw.annotate(@img, 0, 0, offset_x, offset_y, name)

    if is_serving
      @draw.annotate(@img, 0, 0, offset_x+220, offset_y, ' ●')
    end
  end

  def draw_player_points(points, offset_y)
    offset_x = PADDING
    @draw.annotate(@img, 0, 0, offset_x, offset_y, points)
  end

  def draw_player_games(games, offset_y)
    offset_x = PADDING + 80
    @draw.annotate(@img, 0, 0, offset_x, offset_y, games.to_s)
  end

end
