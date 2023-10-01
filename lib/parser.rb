# frozen_string_literal: true

# Class responsible to parse the given log file, fill in the games information and call reports
class Parser
  require 'pry'
  require 'pry-nav'
  require_relative 'game'
  require_relative 'player'

  def initialize(quake_log_path:)
    @quake_log_path = quake_log_path
    @current_game = nil
    @games = []
  end

  def parse
    raise ArgumentError, 'quake_log_path should not be empty' if quake_log_path.nil?
    raise ArgumentError, 'quake_log_path should not be empty' if quake_log_path.empty?

    current_game = nil

    File.readlines(quake_log_path, chomp: true).each do |line|
      if line.match(/InitGame:/)
        current_game = Game.new(number: games.size)
        games << current_game
      else
        current_game = games.last
      end

      next unless line.match(/Kill:/)

      parsed_line = line.match(/(<world>|[\w|\s]+)\skilled\s([\w|\s]+)by\s([\w|\s]+)/)
      next unless parsed_line

      killer_name = parsed_line[1]&.strip
      victim_name = parsed_line[2]&.strip

      current_game.parse_kill(killer_name, victim_name)
    end
    games_report(games)
  end

  private

  def games_report(games)
    games.map(&:report)
  end

  attr_reader :quake_log_path, :current_game, :games
end
