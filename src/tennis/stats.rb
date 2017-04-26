class Stats

  def initialize(match)
    @match = match
  end

  def duration
    start  = TimeUtil.timestamp_to_seconds( @match.points.first.start )
    finish = TimeUtil.timestamp_to_seconds( @match.points.last.finish )
    finish - start
  end

  def scoreline
    @match.scoreline
  end

  def aces
    [1, 2].map do |id|
      @match.points.count { |p| p.server_id == id && p.ace }
    end
  end

  def double_faults
    [1, 2].map do |id|
      @match.points.count { |p| p.server_id == id && p.double_fault? }
    end
  end

  def serve_1_in_percentage
    [1, 2].map do |id|
      served = @match.points.select { |p| p.server_id == id }
      served_in = served.select(&:serve_1)

      (served_in.count.to_f / served.count.to_f).round(2)
    end
  end

  def serve_1_points_won_percentage
    [1, 2].map do |id|
      played = @match.points.select { |p| p.server_id == id && p.serve_1 }
      won = played.select { |p| p.winner_id == id }

      (won.count.to_f / played.count.to_f).round(2)
    end
  end

  def serve_2_points_won_percentage
    [1, 2].map do |id|
      played = @match.points.select { |p| p.server_id == id && !p.serve_1 }
      won = played.select { |p| p.winner_id == id }

      (won.count.to_f / played.count.to_f).round(2)
    end
  end

  def winners
    [1, 2].map do |id|
      @match.points.count { |p| p.winner_id == id && p.winner? }
    end
  end

  def unforced_errors
    [1, 2].map do |id|
      @match.points.count { |p| p.winner_id != id && p.unforced? }
    end
  end

  def net_points
    [1, 2].map do |id|
      played = @match.points.select { |p| p.net_point.include?(id) }
      won = played.select { |p| p.winner_id == id }

      [ won.count, played.count ]
    end
  end

  def break_points
    [1, 2].map do |id|
      played, won = 0, 0

      @match.games.each do |game|
        game.each_with_index do |point, index|
          if Game.break_point?(game, index) && point.server_id != id
            played += 1
            won    += 1 if point.winner_id == id
          end
        end
      end

      [ won, played ]
    end
  end

  def to_s
    [
      "Duration: #{duration}",
      "Scoreline: #{scoreline}",
      "Aces: #{aces}",
      "Double Faults: #{double_faults}",
      "First Serve In %: #{serve_1_in_percentage}",
      "First Serve Points Won % #{serve_1_points_won_percentage}",
      "Second Serve Points Won % #{serve_2_points_won_percentage}",
      "Winners: #{winners}",
      "Unforced Errors: #{unforced_errors}",
      "Net Points Won: #{net_points}",
      "Break Points Won: #{break_points}",
    ].join("\n")
  end

end
