require_relative 'board'
require_relative 'player'
require 'yaml'

class Game

  def initialize(player1, player2)
    @player1, @player2 = player1, player2
    @game_board = Board.new
    play
  end

  private

    def play
      player = @player1

      until won?(player)
        begin
          puts "\n#{player.name.capitalize}'s turn. #{player.color.capitalize} pieces."

          @game_board.display

          moves_array = get_input(player)

          @game_board.move!(moves_array)

        rescue IOError => e
          puts e.message
          retry
        end

        player == @player1 ? player = @player2 : player = @player1
      end
    end

    def won?(player)
      return true if @game_board.pieces(opponent(player.color)).empty?

      if @game_board.pieces(opponent(player.color)).all? { |piece| piece.all_moves.empty? }
        return true
      end

      false
    end

    def opponent(color)
      color == :white ? :black : :white
    end

    def get_input(player)
      puts "#{player.name.capitalize}, where would you like to move from?"
      start_pos = gets.chomp.split("")

      unless Integer(start_pos.first) && Integer(start_pos.last)
        raise IOError.new "Please enter two numbers with a space between each number."
      end
      start_pos.map! { |n| n.to_i }

      puts "Where would you like to move to?"
      puts "If jumping, put in each position you will jump to in order."
      end_pos = gets.chomp.split("")

      unless Integer(end_pos.first) && Integer(end_pos.last)
        raise IOError.new "Please enter two numbers with a space between each number."
      end

      end_pos.map! { |n| n.to_i }

      moves_array = [start_pos]

      until end_pos.empty?
        move = [end_pos.shift, end_pos.shift]
        end_pos.shift
        moves_array << move
      end

      moves_array
    end
end

if __FILE__ == $PROGRAM_NAME

  unless ARGV.empty?
    YAML.load_file(ARGV.shift).play
  else
    puts "Who is playing as white?"
    name = gets.chomp
    player1 = Player.new(name, :black)

    puts "Who is playing as black?"
    name = gets.chomp
    player2 = Player.new(name, :white)

    Game.new(player1, player2)
  end
end


# g = Game.new(Player.new("Tom", :black), Player.new("Chelsea", :white))
# g = Game.new(tom, chelsea)
