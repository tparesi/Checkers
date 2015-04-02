class Piece

  def initialize
    @position


  end

  def perform_slide
    

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
