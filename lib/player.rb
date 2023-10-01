class Player
  WORLD_PLAYER_NAME = '<world>'

  def initialize(name:)
    @name = name
  end

  def world?
    name == WORLD_PLAYER_NAME
  end

  attr_reader :name
end
