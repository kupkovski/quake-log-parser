# frozen_string_literal: true

require_relative './kill'
require_relative './game_reporter'

# Class responsible to handle the kills and
# report it's content
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
    GameReporter.new(kills:, game_name: name).report
  end

  private

  def killer(name) = Player.new(name:)
  def victim(name) = Player.new(name:)

  attr_reader :number
end
