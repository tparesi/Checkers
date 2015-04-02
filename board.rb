require_relative 'piece'
require 'colorize'
require 'byebug'

class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    place_pieces
  end

  def move!(moves_array)
    if moves_array.length == 2
      move(moves_array.first, moves_array.last)
    else
      start_pos = moves_array.shift
      end_array = moves_array

      until end_array.empty?
        next_start_pos = end_array.shift
        move(start_pos, next_start_pos)
        start_pos = next_start_pos
      end
    end
  end

  def move(start_pos, end_pos)
    raise IOError.new 'No piece at position.' unless self[start_pos]

    piece = self[start_pos]

    if piece.possible_jump_moves.include?(end_pos)
      perform_jump(start_pos, end_pos)
    elsif piece.possible_slide_moves.include?(end_pos)
      perform_slide(start_pos, end_pos)
    end

    piece.king = true if self[end_pos].maybe_promote?
  end

  def perform_jump(start_pos, end_pos)
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
    raise IOError.new 'Invalid position.' unless in_bounds?(pos)

    @grid[pos.first][pos.last]
  end

  def []=(pos, value)
    raise IOError.new 'Invalid position.' unless in_bounds?(pos)

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
      [[0,1], [0,3], [0,5], [0,7], [1,0], [1,2], [1,4], [1,6], [2,1], [2,3], [2,5], [2,7]]
        .each { |pos| Piece.new(pos, :black, self) }

      #white
      [[5,0], [5,2], [5,4], [5,6], [6,1], [6,3], [6,5], [6,7], [7,0], [7,2], [7,4], [7,6]]
        .each { |pos| Piece.new(pos, :white, self) }
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
