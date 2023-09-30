class Parser
  require 'pry'
  require 'pry-nav'
  require_relative 'game'
  require_relative 'player'

  def initialize(quake_log_path:)
    @quake_log_path = quake_log_path
    @current_game = nil
  end

  def parse
    raise ArgumentError, 'quake_log_path should not be empty' if quake_log_path.nil?
    raise ArgumentError, 'quake_log_path should not be empty' if quake_log_path.empty?
    games = {}
    game_number = 0


    File.readlines(quake_log_path, chomp: true).each do |line|
      if line.match(/InitGame\:/)
        @current_game = Game.new(number: game_number)
        games[game_number] ||= current_game
        game_number += 1
      end

      if line.match(/Kill\:/)
        parsed_line = line.match(/(<world>|[\w|\s]+)\skilled\s([\w|\s]+)by\s([\w|\s]+)/)

        if parsed_line
          killer_name = parsed_line[1]&.strip
          victim_name = parsed_line[2]&.strip

          killer = Player.new(name: killer_name)
          victim = Player.new(name: victim_name)

          current_game.add_kill(killer:, victim:)
        end
      end
    end
    games.map { |game_number, game| game.report }
  end

  private

  attr_reader :quake_log_path, :current_game
end

