# frozen_string_literal: true

require 'pry'
require 'rspec'
include RSpec::Matchers

sample_input = <<~HEREDOC.split("\n")
  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
  8  2 23  4 24
  21  9 14 16  7
  6 10  3 18  5
  1 12 20 15 19

  3 15  0  2 22
  9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
  2  0 12  3  7
HEREDOC

actual_input = File.read('input.txt').split("\n")

# Part 1
def perform(input)
  draws = input.shift.split(',').map(&:to_i)
  number_of_boards = input.length / 6

  boards = (1..number_of_boards).map { |index|
    input
      .slice(index + ((index.pred) * 5), 5)
      .map { |row| row.split(' ').map(&:to_i) }
  }

  draws.reduce(boards) do |memo, draw|
    winning, remaining = memo.map { |board|
      board.map { |row| row.map { |value| value == draw ? nil : value } }
    }.partition { |board|
      board.any? { |row| row.all?(&:nil?) } || board.transpose.any? { |column| column.all?(&:nil?) }
    }

    break draw * winning.first.flatten.sum(&:to_i) if winning.any?

    remaining
  end
end

expect(perform(sample_input.dup)).to eq(4512)
expect(perform(actual_input.dup)).to eq(32844)

# Part 2
def perform(input)
  draws = input.shift.split(',').map(&:to_i)
  number_of_boards = input.length / 6

  boards = (1..number_of_boards).map { |index|
    input
      .slice(index + ((index.pred) * 5), 5)
      .map { |row| row.split(' ').map(&:to_i) }
  }

  draws.reduce(boards) do |memo, draw|
    winning, remaining = memo.map { |board|
      board.map { |row| row.map { |value| value == draw ? nil : value } }
    }.partition { |board|
      board.any? { |row| row.all?(&:nil?) } || board.transpose.any? { |column| column.all?(&:nil?) }
    }

    break draw * winning.first.flatten.sum(&:to_i) if remaining.none?

    remaining
  end
end

expect(perform(sample_input.dup)).to eq(1924)
expect(perform(actual_input.dup)).to eq(4920)
