class Point

  attr_reader :set, :game,
              :video_finish, :start, :finish,
              :server_id, :serve_1, :serve_2, :ace,
              :winner_id, :win_type, :net_point, :break_point

  WIN_TYPES = %w(WINNER FORCED UNFORCED BAD_CALL SKIPPED)

  def initialize(args)
    @set  = args[:set]
    @game = args[:game]

    @start        = args[:start]
    @finish       = args[:finish]
    @video_finish = args[:video_finish]

    @server_id = args[:server_id]
    @serve_1   = args[:serve_1]
    @serve_2   = args[:serve_2]
    @ace       = args[:ace]

    @winner_id = args[:winner_id]
    @win_type  = args[:win_type]

    @net_point = []
    @net_point << 1 if args[:net_point_p1]
    @net_point << 2 if args[:net_point_p2]

    @break_point = false
  end

  def double_fault?
    @serve_1 == false && @serve_2 == false
  end

  def winner?
    @win_type.upcase == WIN_TYPES[0]
  end

  def unforced?
    @win_type.upcase == WIN_TYPES[2]
  end

  def break_point!
    @break_point = true
  end

  def break_point?
    @break_point == true
  end

  # def to_s
  #   "WINNER = #{@winner_id}"
  # end

end
