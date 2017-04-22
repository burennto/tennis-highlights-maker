class Video

  attr_reader :path, :start, :finish

  def initialize(path, start=nil, finish=nil)
    @path = path
    @start, @finish = start, finish
  end

end
