class Game

  def self.winner(points)
    p1, p2 = points.partition { |p| p.winner_id == 1 }.map(&:count)

    return nil unless p1 >= 4 || p2 >= 4

    return 1 if p1 > p2 && p1 - p2 >= 2
    return 2 if p2 > p1 && p2 - p1 >= 2

    nil
  end

  def self.over?(points)
    winner(points)
  end

  def self.break_point?(points, index)
    points = points.slice(0..index)
    points.pop

    server   = points.count { |p| p.server_id == p.winner_id }
    receiver = points.count { |p| p.server_id != p.winner_id }

    receiver+1 >= 4 && (receiver+1) - server >= 2
  end

end

class Match

  attr_reader :points

  def initialize
    @points = []
  end

  def point!(point)
    @points << point
  end

  def sets
    @points.group_by(&:set)
  end

  def games(set_no: nil)
    points = @points
    points.select! { |p| p.set == set_no } if set_no
    points.chunk(&:game).map(&:last)
  end

  def games_won(id:, set_no: nil)
    games(set_no: set_no).partition { |game| Game.winner(game) == id }.first
  end

  def scoreline
    sets.map.with_index do |set, i|
      [1, 2].map { |id| games_won(id: id, set_no: i+1).count }
    end
  end

  def snapshot(point_no)
    if point_no == 0
      {
        point_no: 0,
        games: [
          games_won(id: 1).count,
          games_won(id: 2).count
        ],
        points: [ 0, 0 ],
      }
    end
  end

  def to_s
    @points.map.with_index { |p, i| "POINT #{i+1}" }.join("\n")
  end

end










class Match2

  attr_reader :sets, :p1, :p2

  def initialize(p1, p2)
    @sets = [ Set.new(1) ]
    @p1, @p2 = p1, p2
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
