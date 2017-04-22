class Set

  attr_reader :number, :games

  def initialize(number)
    @number = number
    @games = [ Game.new(1) ]
  end

  def point!(point)
    current_game = @games.last
    current_game.point!(point)

    return if over?

    if current_game.over?
      @games << Game.new(@games.count+1)
    end
  end

  def winner
    p1 = @games.count { |g| g.winner == 1 }
    p2 = @games.count { |g| g.winner == 2 }

    return nil unless p1 >= 6 || p2 >= 6

    return 1 if (p1 - p2) >= 2
    return 2 if (p1 - p2) >= 2

    nil
  end

  def over?
    winner
  end

end
