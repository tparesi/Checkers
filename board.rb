require_relative 'piece'
require 'colorize'

class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def display
    puts render
  end

  private

    def render
      background = :gray
      nums = ("1".."8").to_a

      "   " + ('a'..'h').to_a.join("  ") + "\n" +
      @grid.map do |row|
        background == :red ? background = :gray : background = :red

        (nums.shift + " ") + row.map do |piece|
          background == :red ? background = :gray : background = :red

          if piece.nil?
            ("   ").colorize(:background => background)
          else
            (' ' + piece.render + ' ').colorize(:background => background)
          end

        end.join("")
      end.join("\n")
    end

end
