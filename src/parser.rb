class Parser

  require 'pry'
  require 'pry-nav'

  def initialize(quake_log_path:)
    @quake_log_path = quake_log_path
  end

  def parse
    raise ArgumentError, 'quake_log_path should not be empty' if quake_log_path.nil?
    raise ArgumentError, 'quake_log_path should not be empty' if quake_log_path.empty?
    games = {}
    game_number = 0


    File.readlines(quake_log_path, chomp: true).each do |line|
      if line.match(/InitGame\:/)
        game_number += 1
        games[game_number] ||= {}
      end

      if line.match(/Kill\:/)
        parsed_line = line.match(/(<world>|[\w|\s]+)\skilled\s([\w|\s]+)by\s([\w|\s]+)/)
        if parsed_line
          games[game_number]['total_kills'] ||= 0
          games[game_number]['total_kills'] += 1

          killer_char = parsed_line[1]&.strip
          killed_char = parsed_line[2]&.strip
          killing_method = parsed_line[3]&.strip

          games[game_number]['players'] ||= []
          games[game_number]['players'] << killed_char if !games[game_number]['players'].include?(killed_char)
          games[game_number]['players'] << killer_char if killer_char != '<world>' && !games[game_number]['players'].include?(killer_char)

          games[game_number]['kills'] ||= {}

          # binding.pry
          if killer_char == '<world>'
            games[game_number]['kills'][killed_char] ||= 0
            games[game_number]['kills'][killed_char] -= 1
          else
            games[game_number]['kills'][killer_char] ||= 0
            games[game_number]['kills'][killer_char] += 1
          end

        end
      end

    end

    games
  end

  private
  attr_reader :quake_log_path
end

# expected result:
# "game_1": {
# "total_kills": 45,
# "players": ["Dono da bola", "Isgalamido", "Zeh"],
# "kills": {
#   "Dono da bola": 5,
#   "Isgalamido": 18,
#   "Zeh": 20
#   }
# }
