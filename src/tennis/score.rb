class Score

  def self.pretty(player, opponent)
    case
    when player == 0 && opponent == 0 then ''
    when player == 0 then '0'
    when player == 1 then '15'
    when player == 2 then '30'
    when player == opponent then '40'
    when player > opponent && opponent < 3 then '40'
    when player > opponent && opponent >= 3 then 'Ad'
    when player < opponent then ''
    else
    end
  end

end
