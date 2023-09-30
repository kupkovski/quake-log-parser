require_relative './kill'

class Game
  attr_reader :killers, :victims, :kills

  def initialize(number:)
    @number = number
    @kills = []
  end

  def name
    "game_#{number + 1}"
  end

  def add_kill(killer:, victim:)
    @kills << Kill.new(killer:, victim:)
  end

  # def add_killer(player)
  #   @killers << player
  # end

  # def add_victim(player)
  #   @victims << player
  # end

  def total_kills
    kills.count
  end

  def all_players
    (kills.map(&:killer) + kills.map(&:victim)).reject do |player|
      player.world?
    end.uniq(&:name).sort_by(&:name)
  end

  def all_player_names
    all_players.map(&:name)
  end

  def report
    {
      name => {
        "total_kills" => total_kills,
        "players" => all_player_names,
        "kills" => kills.reduce({}) do |result, kill|
                                      if kill.killer.world?
                                        result[kill.victim.name] ||= 0
                                        result[kill.victim.name] -= 1
                                      else
                                        result[kill.killer.name] ||= 0
                                        result[kill.killer.name] += 1
                                      end
                                        result
                                      end
      }
    }
  end

  private

  attr_reader :number
end
