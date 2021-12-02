# frozen_string_literal: true

require 'rspec'
include RSpec::Matchers

sample_input = <<~HEREDOC.split("\n")
  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
HEREDOC

actual_input = File.read('input.txt').split("\n")

# Part 1
def perform(input)
  input.reduce([0, 0]) do |position, command|
    direction, value = command.split(' ')

    case direction
    when 'forward'
      [position[0] + value.to_i, position[1]]
    when 'down'
      [position[0], position[1] + value.to_i]
    when 'up'
      [position[0], position[1] - value.to_i]
    end
  end.inject(:*)
end

expect(perform(sample_input)).to eq(150)
expect(perform(actual_input)).to eq(2070300)

# Part 2
def perform(input)
  input.reduce({ x: 0, y: 0, aim: 0 }) do |memo, command|
    direction, value_str = command.split(' ')
    value = value_str.to_i

    case direction
    when 'forward'
      memo.merge(
        x: memo[:x] + value,
        y: memo[:y] + (memo[:aim] * value)
      )
    when 'down'
      memo.merge(aim: memo[:aim] + value)
    when 'up'
      memo.merge(aim: memo[:aim] - value)
    end
  end.slice(:x, :y).values.inject(:*)
end

expect(perform(sample_input)).to eq(900)
expect(perform(actual_input)).to eq(2078985210)
