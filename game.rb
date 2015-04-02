require_relative 'board'

class Game

  def initialize
    @game_board = Board.new
    play
  end

  def play
    loop do
      @game_board.display

      start_pos, end_pos = get_input

      @game_board.move(start_pos, end_pos)
    end
  end

  def get_input
    puts "Where would you like to move from?"
    start_pos = gets.chomp.split("").map { |n| n.to_i }

    puts "Where would you like to move to?"
    end_pos = gets.chomp.split("").map { |n| n.to_i }

    [start_pos, end_pos]
  end
end
