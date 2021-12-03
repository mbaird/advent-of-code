# frozen_string_literal: true

require 'rspec'
include RSpec::Matchers

sample_input = <<~HEREDOC.split("\n")
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
HEREDOC

actual_input = File.read('input.txt').split("\n")

# Part 1
def perform(input)
  gamma = input.map { |row|
    row.chars.map(&:to_i)
  }.transpose.map { |column|
    column.tally.max_by { |k, v| [v, k] }.first
  }

  epsilon = gamma.map { |v| 1 - v }

  epsilon.join.to_i(2) * gamma.join.to_i(2)
end

expect(perform(sample_input)).to eq(198)
expect(perform(actual_input)).to eq(3687446)

# Part 2
def perform(input)
  rows = input.map(&:chars)

  result = (0..rows.first.length.pred).reduce(Hash.new('')) do |memo, index|
    memo.merge(
      oxygen: memo[:oxygen] + rows.select { |row|
        row.join.start_with?(memo[:oxygen])
      }.transpose[index].tally.max_by { |k, v| [v, k] }.first,
      scrubber: memo[:scrubber] + rows.select { |row|
        row.join.start_with?(memo[:scrubber])
      }.transpose[index].tally.min_by { |k, v| [v, k] }.first
    )
  end

  result[:oxygen].to_i(2) * result[:scrubber].to_i(2)
end

expect(perform(sample_input)).to eq(230)
expect(perform(actual_input)).to eq(4406844)
