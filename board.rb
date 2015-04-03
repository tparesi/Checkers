require_relative 'piece'
require 'colorize'
require 'byebug'

class Board

  def initialize(place_new_pieces = true)
    @grid = Array.new(8) { Array.new(8) }
    place_pieces if place_new_pieces
  end

  def perform_moves(moves_array)
    dup_board = self.deep_dup
    dup_moves_array = moves_array.dup
    real_moves_array = moves_array.dup

    if dup_board.perform_moves!(dup_moves_array)
      perform_moves!(real_moves_array)
    else
      raise IOError.new "Invalid moves sequence."
    end

    self[moves_array.last].king = true if self[moves_array.last].maybe_promote?
  end

  def perform_moves!(moves_array)
    raise IOError.new 'No piece at position.' unless self[moves_array[0]]

    if moves_array.length == 2 && perform_slide(moves_array.first, moves_array.last)
    elsif moves_array.length == 2 && perform_jump(moves_array.first, moves_array.last)
    else
      start_pos = moves_array.shift
      end_array = moves_array

      until end_array.empty?
        next_start_pos = end_array.shift
        if perform_jump(start_pos, next_start_pos)
          start_pos = next_start_pos
        else
          return false
        end
      end
    end

    true
  end

  def perform_jump(start_pos, end_pos)
    piece = self[start_pos]

    if piece.possible_jump_moves.include?(end_pos)
      piece.pos = end_pos
      self[space_between(start_pos, end_pos)] = nil
      self[start_pos] = nil
      self[end_pos] = piece
      return true
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
      return true
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

  def deep_dup
    new_board = Board.new(false)

    all_pieces.each do |piece|
      new_board[piece.pos] = Piece.new(piece.pos, piece.color, new_board, piece.king)
    end

    new_board
  end

  def pieces(color)
    all_pieces.select { |piece| piece.color == color }
  end

  private

    def all_pieces
      @grid.flatten.compact
    end

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
