class Game

  attr_reader :number, :points

  def initialize(number)
    @number = number
    @points = []
  end

  def point!(point)
    point.break_point! if is_break_point?(point)
    @points << point
  end

  def winner
    p1 = @points.count { |p| p.winner_id == 1 }
    p2 = @points.count { |p| p.winner_id == 2 }

    return nil unless p1 >= 4 || p2 >= 4

    return 1 if (p1 - p2) >= 2
    return 2 if (p2 - p1) >= 2

    nil
  end

  def over?
    winner
  end

  private

  def is_break_point?(point)
    server   = @points.count { |point| point.server_id == point.winner_id }
    receiver = @points.count { |point| point.server_id != point.winner_id }

    receiver+1 >= 4 &&
    (receiver+1) - server >= 2
  end

end
