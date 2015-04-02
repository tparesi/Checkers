require_relative 'piece'
require 'colorize'
require 'byebug'

class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    place_pieces
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]

    if piece.possible_jump_moves.include?(end_pos)
      perform_jump(start_pos, end_pos)
    elsif piece.possible_slide_moves.include?(end_pos)
      perform_slide(start_pos, end_pos)
    end

    piece.king = true if self[end_pos].maybe_promote?
  end

  def perform_jump(start_pos, end_pos)
    raise 'no piece at pos' unless self[start_pos]

    piece = self[start_pos]

    if piece.possible_jump_moves.include?(end_pos)
      piece.pos = end_pos
      self[space_between(start_pos, end_pos)] = nil
      self[start_pos] = nil
      self[end_pos] = piece
    else
      false
    end
  end

  def perform_slide(start_pos, end_pos)
    raise 'no piece at pos' unless self[start_pos]

    piece = self[start_pos]

    if piece.possible_slide_moves.include?(end_pos)
      piece.pos = end_pos
      self[start_pos] = nil
      self[end_pos] = piece
    else
      false
    end
  end

  def display
    puts render
  end

  def [](pos)
    raise 'invalid pos' unless in_bounds?(pos)

    @grid[pos.first][pos.last]
  end

  def []=(pos, value)
    raise 'invalid pos' unless in_bounds?(pos)

    @grid[pos.first][pos.last] = value
  end

  def in_bounds?(pos)
    row, col = pos
    row.between?(0, 7) && col.between?(0, 7)
  end

  def inspect
    display
  end

  private

    def all_pieces
      @grid.flatten.compact
    end

    def pieces(color)
      all_pieces.select { |piece| piece.color == color }
    end

    # A Player must jump if they can. Put in feature later.
    #
    # def force_jump?(color)
    #   pieces(color).any? do |piece|
    #     piece.possible_jump_moves.count > 0
    #   end
    # end

    def space_between(start_pos, end_pos)
      [(start_pos.first + end_pos.first) / 2, (start_pos.last + end_pos.last) / 2]
    end

    def place_pieces

      #black
      Piece.new([0,1], :black, self)
      Piece.new([0,3], :black, self)
      Piece.new([0,5], :black, self)
      Piece.new([0,7], :black, self)
      Piece.new([1,0], :black, self)
      Piece.new([1,2], :black, self)
      Piece.new([1,4], :black, self)
      Piece.new([1,6], :black, self)
      Piece.new([2,1], :black, self)
      Piece.new([2,3], :black, self)
      Piece.new([2,5], :black, self)
      Piece.new([2,7], :black, self)

      #white
      Piece.new([5,0], :white, self)
      Piece.new([5,2], :white, self)
      Piece.new([5,4], :white, self)
      Piece.new([5,6], :white, self)
      Piece.new([6,1], :white, self)
      Piece.new([6,3], :white, self)
      Piece.new([6,5], :white, self)
      Piece.new([6,7], :white, self)
      Piece.new([7,0], :white, self)
      Piece.new([7,2], :white, self)
      Piece.new([7,4], :white, self)
      Piece.new([7,6], :white, self)
    end

    def render
      background = :red
      nums = ("0".."7").to_a

      "   " + ('0'..'7').to_a.join("  ") + "\n" +
      @grid.map do |row|
        background == :red ? background = :white : background = :red

        (nums.shift + " ") + row.map do |piece|
          background == :red ? background = :white : background = :red

          if piece.nil?
            ("   ").colorize(:background => background)
          else
            (' ' + piece.render + ' ').colorize(:background => background)
          end

        end.join("")
      end.join("\n")
    end

end
