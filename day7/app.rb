# frozen_string_literal: true

require 'pry'
require 'rspec'
include RSpec::Matchers

sample_input = "16,1,2,0,4,2,7,1,2,14"
actual_input = File.read('input.txt')

# Part 1
def perform(input)
  positions = input.split(',').map(&:to_i).sort

  mid = positions.length / 2
  median = (positions[mid.floor] + positions[mid.ceil]) / 2

  positions.reduce(0) do |count, position|
    count + (position - median).abs
  end
end

expect(perform(sample_input)).to eq(37)
expect(perform(actual_input)).to eq(356958)

# Part 2
def perform(input)
  positions = input.split(',').map(&:to_i)

  mean = (positions.sum / positions.length.to_f)

  [mean.floor, mean.ceil].map { |rounded_mean|
    positions.reduce(0) { |fuel, position|
      distance = (position - rounded_mean).abs
      fuel + (distance * ((distance + 1) / 2.0))
    }.round
  }.min
end

expect(perform(sample_input)).to eq(168)
expect(perform(actual_input)).to eq(105461913)
