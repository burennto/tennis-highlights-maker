require 'rmagick'
include Magick

class TitleOverlay

  IMG_WIDTH  = 600
  IMG_HEIGHT = 91

  FONT_FAMILY = 'helvetica'
  FONT_SIZE_HEADING = 30
  FONT_SIZE_SUBHEADING = 22
  FONT_COLOR = 'white'

  BG_COLOR = 'black'

  BORDER_WIDTH = 3
  BORDER_COLOR = 'white'
  STROKE_COLOR = 'white'

  PADDING = 14

  def initialize(title:, date:)
    @title, @date = title, date

    @img = Image.new(IMG_WIDTH, IMG_HEIGHT) { self.background_color = BG_COLOR }

    @draw = Magick::Draw.new
    @draw.font_family = FONT_FAMILY
    @draw.pointsize = FONT_SIZE_HEADING
    @draw.fill = FONT_COLOR
    @draw.stroke = BORDER_COLOR
    @draw.stroke_width = BORDER_WIDTH
    @draw.stroke_antialias(false)
    @draw.text_antialias(false)
    @draw.interline_spacing = 0
    @draw.gravity = Magick::WestGravity
  end

  def to_png(destination)
    draw_borders

    @draw.stroke = 'transparent'
    @draw.stroke_width = 0

    draw_title
    draw_date

    @img.write(destination)
  end

  private

  def draw_borders
    @img.border!(BORDER_WIDTH, BORDER_WIDTH, BORDER_COLOR)
    @draw.line(0, IMG_HEIGHT/2 + BORDER_WIDTH, IMG_WIDTH+BORDER_WIDTH, IMG_HEIGHT/2 + BORDER_WIDTH)
    @draw.draw(@img)
  end

  def draw_title
    @draw.pointsize = FONT_SIZE_HEADING

    offset_x = PADDING
    offset_y = (IMG_HEIGHT * -0.25)
    @draw.annotate(@img, 0, 0, offset_x, offset_y, @title)
  end

  def draw_date
    @draw.pointsize = FONT_SIZE_SUBHEADING

    offset_x = PADDING
    offset_y = (IMG_HEIGHT * 0.25) + 3
    @draw.annotate(@img, 0, 0, offset_x, offset_y, @date)
  end
end
