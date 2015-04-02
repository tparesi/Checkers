require_relative 'board'
require_relative 'player'
require 'yaml'

class Game

  def initialize(player1, player2)
    @player1, @player2 = player1, player2
    @game_board = Board.new
    play
  end

  def play
    player = @player1

    loop do
      puts "\n#{player.name.capitalize}'s turn."

      @game_board.display

      start_pos, end_pos = get_input(player)

      @game_board.move(start_pos, end_pos)

      player == @player1 ? player = @player2 : player = @player1
    end
  end

  def get_input(player)
    begin
      puts "#{player.name.capitalize}, where would you like to move from?"
      start_pos = gets.chomp.split(" ")

      if start_pos.first.is_a?(Integer) && start_pos.last.is_a?(Integer)
        raise IOError.new "Please enter two numbers with a space between each number."
      end
      start_pos.map! { |n| n.to_i }

      puts "Where would you like to move to?"
      end_pos = gets.chomp.split(" ")

      if end_pos.first.is_a?(Integer) && end_pos.last.is_a?(Integer)
        raise IOError.new "Please enter two numbers with a space between each number."
      end

      end_pos.map! { |n| n.to_i }

    rescue IOError => e
      puts e.message
      retry
    end

    [start_pos, end_pos]
  end
end

if __FILE__ == $PROGRAM_NAME

  unless ARGV.empty?
    YAML.load_file(ARGV.shift).play
  else
    puts "Who is playing as white?"
    name = gets.chomp
    player1 = Player.new(name, :white)

    puts "Who is playing as black?"
    name = gets.chomp
    player2 = Player.new(name, :black)

    Game.new(player1, player2)
  end
end
