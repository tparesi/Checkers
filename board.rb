require_relative 'piece'
require 'colorize'

class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def perform_slide(start_pos, end_pos)
    raise 'no piece at pos' unless @grid[start_pos]

    piece = @grid[start_pos]

    if piece.possible_moves.include?(end_pos)
      piece.pos = end_pos
      @grid[start_pos] = nil
      @grid[end_pos] = piece
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
    x, y = pos
    x.between?(0, 7) && y.between?(0, 7)
  end

  private

    def render
      background = :red
      nums = ("1".."8").to_a

      "   " + ('a'..'h').to_a.join("  ") + "\n" +
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
