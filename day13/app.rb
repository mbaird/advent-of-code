# frozen_string_literal: true

require 'pry'
require 'rspec'
include RSpec::Matchers

sample_input = <<~HEREDOC
  6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0

  fold along y=7
  fold along x=5
HEREDOC
actual_input = File.read('input.txt')

def apply_fold(direction, value, coordinates)
  coordinates.reduce([]) { |memo, (x, y)|
    if direction == 'y'
      if y < value.to_i
        memo << [x, y]
      else
        memo << [x, (y - (2 * value.to_i)).abs]
      end
    else
      if x < value.to_i
        memo << [x, y]
      else
        memo << [(x - (2 * value.to_i)).abs, y]
      end
    end
  }
end

def parse_input(input)
  lines = input.lines.map(&:strip)
  split = lines.index('')

  coordinates = lines[...split].map { |set|
    set.split(',').map(&:to_i)
  }
  folds = lines[split.next..].map { |set|
    /([xy])=(\d+)/.match(set).captures
  }

  [coordinates, folds]
end

# Part 1
def perform(input)
  coordinates, folds = parse_input(input)
  direction, value = folds[0]

  coordinates = apply_fold(direction, value, coordinates)

  coordinates.uniq.count
end

expect(perform(sample_input)).to eq(17)
expect(perform(actual_input)).to eq(785)

# Part 2
def perform(input)
  coordinates, folds = parse_input(input)

  coordinates = folds.reduce(coordinates) { |memo, (direction, value)|
    apply_fold(direction, value, memo)
  }

  width, height = coordinates.transpose.map(&:max).map(&:next)

  (width * height).times do |i|
    row = i / width
    col = i % width

    if coordinates.include?([col, row])
      print '@'
    else
      print ' '
    end

    if col.next == width
      print "\n"
    end
  end
end

perform(sample_input)
perform(actual_input)
