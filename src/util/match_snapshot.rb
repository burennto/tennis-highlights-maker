class MatchSnapshot

  def initialize(points=[])
    @points = points
  end

  def point_no
    @points.count
  end

  def games(set_no: nil)
    points = @points
    points.select! { |p| p.set == set_no } if set_no
    points.chunk(&:game).map(&:last)
  end

  def games_won(id:, set_no: nil)
    games(set_no: set_no).partition { |game| Game.winner(game) == id }.first
  end

  def points_won(id)
    return [] if games.empty? || games.last.empty?
    return [] if Game.over?(games.last)
    games.last.select { |p| p.winner_id == id }
  end

  def to_s
  end

end
