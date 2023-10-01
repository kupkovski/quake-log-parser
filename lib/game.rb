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

  def parse_kill(killer_name, victim_name)
    killer = killer(killer_name)
    victim = victim(victim_name)

    add_kill(killer:, victim:)
  end

  def add_kill(killer:, victim:)
    @kills << Kill.new(killer:, victim:)
  end

  def report
    {
      name => {
        'total_kills' => total_kills,
        'players' => all_player_names,
        'kills' => kills.each_with_object({}) do |kill, result|
                     if kill.killer.world?
                       result[kill.victim.name] ||= 0
                       result[kill.victim.name] -= 1
                     else
                       result[kill.killer.name] ||= 0
                       result[kill.killer.name] += 1
                     end
                   end
      }
    }
  end

  private

  def killer(name) = Player.new(name:)
  def victim(name) = Player.new(name:)

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

  attr_reader :number
end
