require_relative '../overlay/score_overlay'

class MatchLoader

  CSV_OPTIONS = { headers: true, header_converters: :symbol, converters: :all }

  def initialize(match)
    @match = match

    create_score_overlay
  end

  def load_csv(path)
    rows = CSV.read(path, CSV_OPTIONS)
    rows.each { |row| record_point(row) }
  end

  private

  def create_score_overlay
    ScoreOverlay.new(@match).to_png
  end

  def record_point(row)
    point = Point.new(
      start: row[:start],
      finish: row[:finish],

      server_id: row[:server_id],
      serve_1: parse_serve(row[:serve_1]),
      serve_2: parse_serve(row[:serve_2]),
      ace: parse_ace(row[:ace]),

      winner_id: row[:winner_id],
      win_type: row[:win_type],

      net_point_p1: parse_net_point(row[:net_point_p1]),
      net_point_p2: parse_net_point(row[:net_point_p2]),
    )

    @match.point!(point)
    create_score_overlay
  end

  def parse_ace(value)
    !value.to_s.strip.empty?
  end

  def parse_serve(value)
    case value.upcase
    when 'IN' then true
    when 'OUT', 'FAULT' then false
    else nil
    end
  end

  def parse_net_point(value)
    !value.to_s.strip.empty?
  end

end
