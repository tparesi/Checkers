class Piece

  attr_accessor :pos, :board, :king
  attr_reader :color

  def initialize(pos, color, board, king = false )
    @pos, @color, @board, @king = pos, color, board, king
  end

  def perform_slide
    if color == :black
      [[row + 1, col - 1], [row + 1, col + 1]]
    elsif color == :white
      [[row - 1, col - 1], [row - 1, col + 1]]
    end
  end

  def perform_jump

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

end
