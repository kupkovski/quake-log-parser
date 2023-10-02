# frozen_string_literal: true

# Class responsible to parse the given log file, fill in the games information and call reports
class Parser
  require 'pry'
  require 'pry-nav'
  require 'json'
  require_relative 'game'
  require_relative 'player'

  def initialize(quake_log_path:)
    @quake_log_path = quake_log_path
    @games = []
  end

  # rubocop:disable Metrics/MethodLength:
  # rubocop:disable Metrics/AbcSize:
  def parse
    raise ArgumentError, 'quake_log_path should not be empty' if quake_log_path.nil?
    raise ArgumentError, 'quake_log_path should not be empty' if quake_log_path.empty?

    current_game = nil

    File.readlines(quake_log_path, chomp: true).each do |line|
      current_game = get_current_game(line)
      next unless line.match(/Kill:/)

      parsed_line = parse_line(line)
      next unless parsed_line

      killer_name, victim_name = players_names(parsed_line)
      current_game.build_kill(killer_name, victim_name)
    end
    JSON(games_report(games))
  end
  # rubocop:enable Metrics/MethodLength:
  # rubocop:enable Metrics/AbcSize:

  private

  def players_names(parsed_line)
    killer_name = parsed_line[1]&.strip
    victim_name = parsed_line[2]&.strip
    [killer_name, victim_name]
  end

  def parse_line(line)
    line.match(/(<world>|[\w|\s]+)\skilled\s([\w|\s]+)by\s([\w|\s]+)/)
  end

  def get_current_game(line)
    games << Game.new(number: games.size) if line.match(/InitGame:/)
    games.last
  end

  def games_report(games)
    games.map(&:report)
  end

  attr_reader :quake_log_path, :current_game, :games
end
