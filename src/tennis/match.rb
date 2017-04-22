class Match

  attr_reader :sets, :p1, :p2

  def initialize(p1, p2)
    @p1, @p2 = p1, p2
    @sets = [ Set.new(1) ]
  end

  def point!(point)
    current_set = @sets.last
    current_set.point!(point)

    return if over?

    if current_set.over?
      @sets << Set.new(@sets.count+1)
    end
  end

  def winner
    p1 = @sets.count { |s| s.winner == 1 }
    p2 = @sets.count { |s| s.winner == 2 }

    return 1 if p1 > 0
    return 2 if p2 > 0

    nil
  end

  def over?
    winner
  end

  def points
    games = @sets.map(&:games).flatten
    games.map(&:points).flatten
  end

  def games
    @sets.map(&:games).flatten
  end

  def to_s
    @sets.map.with_index do |set, set_index|
      set.games.map.with_index do |game, game_index|
        game.points.map.with_index do |point, point_index|
          [
            "SET #{set_index+1}",
            "GAME #{game_index+1}",
            "POINT #{point_index+1}",
            "SERVER #{point.server_id}",
            "WINNER #{point.winner_id}",
            "#{point.ace ? 'ACE' : ''}",
            "#{point.break_point? ? 'BREAK POINT' : ''}",
            "#{point.break_point? && point.server_id != point.winner_id ? 'BREAK!' : ''}"
          ].join(' | ')
        end.push('------------------------------------------------------------')
      end
    end.join("\n")
  end

end
