# frozen_string_literal: true

require 'rspec'
include RSpec::Matchers

sample_input = <<~HEREDOC.split("\n")
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
HEREDOC
actual_input = File.read('input.txt').split("\n")

def perform(input, diagonals: false)
  input.map { |row|
    row.split(' -> ').map { |pair| pair.split(',').map(&:to_i) }
  }.map { |points|
    [points[0], [(points[1][0] - points[0][0]), (points[1][1] - points[0][1])]]
  }.select { |line|
    diagonals ? line : line[1].any?(&:zero?)
  }.map { |line|
    origin, vector = line

    xs = Range.new(
      *[origin[0] + vector[0], origin[0]].sort
    ).to_a.sort_by { |point| point * vector[0] }

    ys = Range.new(
      *[origin[1] + vector[1], origin[1]].sort
    ).to_a.sort_by { |point| point * vector[1] }

    (0..[xs.length, ys.length].max - 1).map { |i|
      [(xs[i] || origin[0]), (ys[i] || origin[1])]
    }
  }.flatten(1).tally.values.count { |i| i > 1 }
end

expect(perform(sample_input)).to eq(5)
expect(perform(actual_input)).to eq(5145)
expect(perform(sample_input, diagonals: true)).to eq(12)
expect(perform(actual_input, diagonals: true)).to eq(16518)
