class Piece

  attr_accessor :pos, :board, :king
  attr_reader :color

  def initialize(pos, color, board, king = false )
    @pos, @color, @board, @king = pos, color, board, king
  end

  def possible_moves
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
    self.possible_slide_moves.select do |position|
      if board[position].color == opponent(color) && board.position.nil?
        return true
      end

      false
    end

  end

  def move_diffs

  end

  def maybe_promote?

  end

  def render
    if piece.king
      color == :white ? "\u26C1" : "\u26C3"
    else
      color == :white ? "\u26C0" : "\u26C2"
    end
  end

  private

    def opponent[color]
      color == :white ? :black : :white
    end

end
