class Stats

  attr_reader :duration, :scoreline, :aces, :double_faults, :serve_1_in_percentage,
              :serve_1_points_won_percentage, :serve_2_points_won_percentage,
              :winners, :unforced_errors, :net_points_won, :break_points_won

  def initialize(match)
    @match = match
  end

  def analyze!
    @duration  = calculate_duration
    @scoreline = calculate_scoreline

    @aces =          [ find_aces(1), find_aces(2) ]
    @double_faults = [ find_double_faults(1), find_double_faults(2) ]

    @serve_1_in_percentage         = [ find_serve_1_in_percentage(1), find_serve_1_in_percentage(2) ]
    @serve_1_points_won_percentage = [ find_serve_1_points_won_percentage(1), find_serve_1_points_won_percentage(2) ]
    @serve_2_points_won_percentage = [ find_serve_2_points_won_percentage(1), find_serve_2_points_won_percentage(2) ]

    @winners         = [ find_winners(1), find_winners(2) ]
    @unforced_errors = [ find_unforced_errors(1), find_unforced_errors(2) ]

    @net_points_won   = [ find_net_points_won(1), find_net_points_won(2) ]
    @break_points_won = [ find_break_points_won(1), find_break_points_won(2) ]
  end

  def to_s
    [
      "Duration: #{@duration}",
      "Scoreline: #{@scoreline}",
      "Aces: #{@aces}",
      "Double Faults: #{@double_faults}",
      "First Serve In %: #{@serve_1_in_percentage}",
      "First Serve Points Won % #{@serve_1_points_won_percentage}",
      "Second Serve Points Won % #{@serve_2_points_won_percentage}",
      "Winners: #{@winners}",
      "Unforced Errors: #{@unforced_errors}",
      "Net Points Won: #{@net_points_won}",
      "Break Points Won: #{@break_points_won}",
    ].join("\n")
  end

  private

  def calculate_duration
    start  = TimeUtil.timestamp_to_seconds( @match.sets[0].games[0].points[0].start )
    finish = TimeUtil.timestamp_to_seconds( @match.sets[-1].games[-1].points[-1].finish )
    finish - start
  end

  def calculate_scoreline
    @match.sets.map do |set|
      p1 = set.games.count { |game| game.winner == 1 }
      p2 = set.games.count { |game| game.winner == 2 }
      [ p1, p2 ]
    end
  end

  def find_aces(id)
    @match.points.count { |point| point.server_id == id && point.ace }
  end

  def find_double_faults(id)
    @match.points.count { |point| point.server_id == id && point.double_fault? }
  end

  def find_serve_1_in_percentage(id)
    served = @match.points.select { |point| point.server_id == id }
    served_in = served.select { |point| point.serve_1 }

    (served_in.count / served.count.to_f).round(2)
  end

  def find_serve_1_points_won_percentage(id)
    played = @match.points.select { |point| point.server_id == id && point.serve_1 }
    won = played.select { |point| point.winner_id == id }

    (won.count / played.count.to_f).round(2)
  end

  def find_serve_2_points_won_percentage(id)
    played = @match.points.select { |point| point.server_id == id && !point.serve_1 }
    won = played.select { |point| point.winner_id == id }

    (won.count / played.count.to_f).round(2)
  end

  def find_winners(id)
    @match.points.count { |point| point.winner_id == id && point.winner? }
  end

  def find_unforced_errors(id)
    @match.points.count { |point| point.winner_id != id && point.unforced? }
  end

  def find_net_points_won(id)
    played = @match.points.select { |point| point.net_point.include?(id) }
    won = played.select { |point| point.winner_id == id }

    [ won.count, played.count ]
  end

  def find_break_points_won(id)
    played = @match.points.select { |point| point.server_id != id && point.break_point? }
    won = played.select { |point| point.winner_id == id }

    [ won.count, played.count ]
  end

end
