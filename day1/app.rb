# frozen_string_literal: true

require 'rspec'
include RSpec::Matchers

sample_input = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
actual_input = File.read('input.txt').split.map(&:to_i)

# Part 1
def perform(input)
  input.each_with_index.reduce(0) do |count, (current_value, index)|
    next_value = input[index + 1] || -Float::INFINITY

    if next_value > current_value
      count + 1
    else
      count
    end
  end
end

expect(perform(sample_input)).to eq(7)
expect(perform(actual_input)).to eq(1387)

# Part 2
def perform(input)
  input.each_with_index.reduce(0) do |count, (_, index)|
    next count if index + 3 >= input.size

    window = input.slice(index, 3)
    next_window = input.slice(index + 1, 3)

    if next_window.sum > window.sum
      count + 1
    else
      count
    end
  end
end

expect(perform(sample_input)).to eq(5)
expect(perform(actual_input)).to eq(1362)

# SUPER BONUS ROUND
def perform(input, window_size:)
  input.each_index.reduce(0) do |count, index|
    next count if index + window_size >= input.size

    window = input.slice(index, window_size)
    next_window = input.slice(index + 1, window_size)

    if next_window.sum > window.sum
      count + 1
    else
      count
    end
  end
end

expect(perform(sample_input, window_size: 1)).to eq(7)
expect(perform(actual_input, window_size: 1)).to eq(1387)
expect(perform(sample_input, window_size: 3)).to eq(5)
expect(perform(actual_input, window_size: 3)).to eq(1362)
