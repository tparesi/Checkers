require 'byebug'

class Piece

  attr_accessor :pos, :board, :king
  attr_reader :color

  def initialize(pos, color, board, king = false )
    @pos, @color, @board, @king = pos, color, board, king
    @board[@pos] = self
  end

  def all_moves
    possible_slide_moves + possible_jump_moves
  end

  def possible_slide_moves
    row, col = pos

    if king
      [[row - 1, col - 1], [row - 1, col + 1], [row + 1, col - 1], [row + 1, col + 1]]
    else
      if color == :black
        [[row + 1, col - 1], [row + 1, col + 1]]
      elsif color == :white
        [[row - 1, col - 1], [row - 1, col + 1]]
      end
    end
  end

  def possible_jump_moves
    valid_jump_positions = []

    self.possible_slide_moves.each do |position|
      [space_one_away(position)].each do |jpos|
        if board.in_bounds?(jpos) &&
           board[position] &&
           board[position].color == opponent(color) &&
           board[jpos].nil?

           valid_jump_positions << jpos

         end
      end
    end

    valid_jump_positions
  end

  def space_one_away(position)
    row, col = position
    if col - self.pos.last == 1 && row > self.pos.first && col > self.pos.last
      [row + 1, col + 1]
    elsif col - self.pos.last == -1 && row < self.pos.first && col < self.pos.last
      [row - 1, col - 1]
    elsif col - self.pos.last == -1 && row > self.pos.first && col < self.pos.last
      [row + 1, col - 1]
    elsif col - self.pos.last == 1 && row < self.pos.first && col > self.pos.last
      [row - 1, col + 1]
    end
  end

  def maybe_promote?
    if color == :black && pos.first == 7
      return true
    elsif color == :white && pos.first == 0
      return true
    end

    false
  end

  def render
    if king
      color == :white ? "☆" : "★"
    else
      color == :white ? "◎" : "◉"
    end
  end

  private

    def opponent(color)
      color == :white ? :black : :white
    end

end
