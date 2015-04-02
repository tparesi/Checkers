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
      if board[position] && board[position].color == opponent(color) && board[jump_space(position)].nil?
        return true
      end

      false
    end
  end

  def jump_space(position)
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
    else color == :white && pos.first == 0
      return true
    end

    false
  end

  def render
    if king
      color == :white ? "\u26C1" : "\u26C3"
    else
      color == :white ? "\u26C0" : "\u26C2"
    end
  end

  private

    def opponent(color)
      color == :white ? :black : :white
    end

end
