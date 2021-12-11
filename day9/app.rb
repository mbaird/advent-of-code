# frozen_string_literal: true

require 'pry'
require 'rspec'
include RSpec::Matchers

sample_input = <<~HEREDOC
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
HEREDOC
actual_input = File.read('input.txt')

# Part 1
def perform(input)
  data = input.lines.map(&:strip).map { |line| line.chars.map(&:to_i) }
  rows = data.count
  cols = data.first.count

  padded = data
    .unshift([9] * cols).push([9] * cols).transpose
    .unshift([9] * (rows + 2)).push([9] * (rows + 2)).transpose

  (rows * cols).times.sum { |i|
    row = (i / cols) + 1
    col = (i % cols) + 1

    value = padded[row][col]

    left  = padded[row][col - 1]
    right = padded[row][col + 1]
    up    = padded[row - 1][col]
    down  = padded[row + 1][col]

    if value < [up, down, left, right].min
      value + 1
    else
      0
    end
  }
end

expect(perform(sample_input)).to eq(15)
expect(perform(actual_input)).to eq(417)

# Part 2
def perform(input)
  data = input.lines.map(&:strip).map { |line| line.chars.map(&:to_i) }
  rows = data.count
  cols = data.first.count

  padded = data
    .unshift([9] * cols).push([9] * cols).transpose
    .unshift([9] * (rows + 2)).push([9] * (rows + 2)).transpose

  low_points = (rows * cols).times.map { |i|
    row = (i / cols) + 1
    col = (i % cols) + 1

    value = padded[row][col]

    left  = padded[row][col - 1]
    right = padded[row][col + 1]
    up    = padded[row - 1][col]
    down  = padded[row + 1][col]

    if value < [up, down, left, right].min
      [row, col]
    end
  }.compact

  basins = []

  low_points.each do |point|
    basin = []
    expanded = [point]

    loop do
      basin += expanded

      expanded = expanded.reduce([]) do |memo, exp|
        left  = [exp[0] - 1, exp[1]]
        right = [exp[0] + 1, exp[1]]
        up    = [exp[0], exp[1] - 1]
        down  = [exp[0], exp[1] + 1]

        [left, right, up, down].each do |n|
          if padded[n[0]][n[1]] != 9
            memo << n
            padded[n[0]][n[1]] = 9
          end
        end

        memo
      end

      break if expanded.empty?
    end

    basins << basin.uniq
  end

  basins.sort_by(&:length).slice(-3, 3).map(&:count).reduce(:*)
end

expect(perform(sample_input)).to eq(1134)
expect(perform(actual_input)).to eq(1148965)
