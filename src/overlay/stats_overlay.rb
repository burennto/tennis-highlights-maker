require 'rmagick'
include Magick

class StatsOverlay

  IMG_WIDTH  = 620-6
  IMG_HEIGHT = 550-6

  FONT_FAMILY = 'helvetica'
  FONT_SIZE_SMALL = 18
  # FONT_SIZE_MEDIUM = 24
  FONT_SIZE_LARGE = 30

  FONT_COLOR = 'white'
  BG_COLOR = 'black'

  BORDER_WIDTH = 3
  BORDER_COLOR = 'white'
  STROKE_COLOR = 'white'

  PADDING = 14

  def initialize(stats:, title:, date:, p1: , p2:)
    @img = Image.new(IMG_WIDTH, IMG_HEIGHT) { self.background_color = BG_COLOR }

    @draw = Magick::Draw.new
    @draw.font_family = FONT_FAMILY
    @draw.pointsize = FONT_SIZE_SMALL
    @draw.fill = FONT_COLOR
    @draw.stroke = BORDER_COLOR
    @draw.stroke_width = BORDER_WIDTH
    @draw.stroke_antialias(false)
    @draw.text_antialias(false)
    @draw.interline_spacing = 0
    @draw.gravity = Magick::NorthGravity

    @stats = stats
    @title = title
    @p1_name = p1.display_name
    @p2_name = p2.display_name

    @duration  = TimeUtil.seconds_to_timestamp(@stats.duration)
    @scoreline = @stats.scoreline.map { |set| "#{set[0]}-#{set[1]}" }.join(' ')
  end

  def to_png(destination)
    draw_borders

    @draw.stroke = 'transparent'
    @draw.stroke_width = 0

    draw_heading
    draw_stat_names

    draw_player_stats(0, -210)
    draw_player_stats(1, 210)

    @img.write(destination)
  end

  private

  def draw_borders
    @img.border!(BORDER_WIDTH, BORDER_WIDTH, BORDER_COLOR)
    @draw.line(0, 60, IMG_WIDTH+BORDER_WIDTH, 60)
    @draw.draw(@img)
  end

  def draw_heading
    @draw.pointsize = FONT_SIZE_LARGE

    offset_x = 0
    offset_y = PADDING

    @draw.annotate(@img, 0, 0, offset_x, offset_y, @title)
  end

  def draw_stat_names
    @draw.pointsize = FONT_SIZE_LARGE
    offset_x = 0

    offset_y = 72
    @draw.annotate(@img, 0, 0, offset_x, offset_y, @scoreline)

    @draw.pointsize = FONT_SIZE_SMALL
    offset_y = 120
    @draw.annotate(@img, 0, 0, offset_x, offset_y, "MATCH TIME #{@duration}")

    offset_y_distance = 42

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, 'ACES')

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, 'DOUBLE FAULTS')

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, '1st SERVE IN %')

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, '1st SERVE POINTS WON %')

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, '2nd SERVE POINTS WON %')

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, 'WINNERS')

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, 'UNFORCED ERRORS')

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, 'NET POINTS WON')

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, 'BREAK POINTS WON')
  end

  def draw_player_stats(player_index, offset_x)
    @draw.pointsize = FONT_SIZE_SMALL
    offset_y = 75

    i = player_index

    player_name                   = i == 0 ? @p1_name : @p2_name
    aces                          = @stats.aces[i].to_s
    double_faults                 = @stats.double_faults[i].to_s
    serve_1_in_percentage         = (@stats.serve_1_in_percentage[i] * 100).to_i.to_s + '%'
    serve_1_points_won_percentage = (@stats.serve_1_points_won_percentage[i] * 100).to_i.to_s + '%'
    serve_2_points_won_percentage = (@stats.serve_2_points_won_percentage[i] * 100).to_i.to_s + '%'
    winners                       = @stats.winners[i].to_s
    unforced_errors               = @stats.unforced_errors[i].to_s
    net_points                    = "#{@stats.net_points[i][0]}/#{@stats.net_points[i][1]}"
    break_points                  = "#{@stats.break_points[i][0]}/#{@stats.break_points[i][1]}"

    @draw.annotate(@img, 0, 0, offset_x, offset_y, player_name)

    @draw.pointsize = FONT_SIZE_LARGE

    offset_y = 155
    @draw.annotate(@img, 0, 0, offset_x, offset_y, aces)

    offset_y_distance = 42

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, double_faults)

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, serve_1_in_percentage)

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, serve_1_points_won_percentage)

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, serve_2_points_won_percentage)

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, winners)

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, unforced_errors)

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, net_points)

    offset_y += offset_y_distance
    @draw.annotate(@img, 0, 0, offset_x, offset_y, break_points)
  end

end
