# frozen_string_literal: true

# Class responsible to elaborate the Game's report
class GameReporter
  def initialize(kills:, game_name:)
    @kills = kills
    @game_name = game_name
  end

  def report
    {
      game_name => {
        'total_kills' => total_kills,
        'players' => all_player_names,
        'kills' => report_kills
      }
    }
  end

  private

  attr_reader :kills, :game_name

  def report_kills
    kills.each_with_object({}) do |kill, result|
      if kill.killer.world?
        decrement_world_kill(result, kill.victim.name)
      else
        increment_world_kill(result, kill.killer.name)
      end
    end
  end

  def increment_world_kill(result, killer_name)
    result[killer_name] ||= 0
    result[killer_name] += 1
  end

  def decrement_world_kill(result, victim_name)
    result[victim_name] ||= 0
    result[victim_name] -= 1
  end

  def total_kills
    kills.count
  end

  def all_players
    (kills.map(&:killer) + kills.map(&:victim)).reject(&:world?).uniq(&:name).sort_by(&:name)
  end

  def all_player_names
    all_players.map(&:name)
  end
end
