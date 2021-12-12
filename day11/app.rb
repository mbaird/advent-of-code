# frozen_string_literal: true

require 'matrix'
require 'pry'
require 'rspec'
include RSpec::Matchers

sample_input = <<~HEREDOC
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526
HEREDOC
actual_input = File.read('input.txt')

# Part 1
def perform(input, steps: 100)
  grid = Matrix[*input.lines.map(&:strip).map { |row| row.chars.map(&:to_i) }]

  steps.times.sum do
    due_to_flash = []
    already_flashed = []

    grid = grid.map(&:next)

    loop do
      due_to_flash.each do |point|
        row, col = point

        points = [
          [row - 1, col - 1],
          [row - 1, col],
          [row - 1, col + 1],
          [row, col - 1],
          [row, col + 1],
          [row + 1, col - 1],
          [row + 1, col],
          [row + 1, col + 1]
        ]

        points
          .reject { |_, x| x < 0 || x >= grid.column_count }
          .reject { |y, _| y < 0 || y >= grid.row_count }
          .each { |p| grid[*p] += 1 }
      end

      due_to_flash = grid.each_with_index.reduce([]) { |memo, (value, row, col)|
        next memo if already_flashed.include?([row, col]) || value < 10

        memo << [row, col]
      }

      already_flashed += due_to_flash

      break if due_to_flash.empty?
    end

    already_flashed.count { |point| grid[*point] = 0 }
  end
end

expect(perform(sample_input)).to eq(1656)
expect(perform(actual_input)).to eq(1773)

# Part 2
def perform(input, steps: 2000)
  grid = Matrix[*input.lines.map(&:strip).map { |row| row.chars.map(&:to_i) }]

  steps.times do |step|
    due_to_flash = []
    already_flashed = []

    grid = grid.map(&:next)

    loop do
      due_to_flash.each do |point|
        row, col = point

        points = [
          [row - 1, col - 1],
          [row - 1, col],
          [row - 1, col + 1],
          [row, col - 1],
          [row, col + 1],
          [row + 1, col - 1],
          [row + 1, col],
          [row + 1, col + 1]
        ]

        points
          .reject { |_, x| x < 0 || x >= grid.column_count }
          .reject { |y, _| y < 0 || y >= grid.row_count }
          .each { |p| grid[*p] += 1 }
      end

      due_to_flash = grid.each_with_index.reduce([]) { |memo, (value, row, col)|
        next memo if already_flashed.include?([row, col]) || value < 10

        memo << [row, col]
      }

      already_flashed += due_to_flash

      break if due_to_flash.empty?
    end

    already_flashed.each { |point| grid[*point] = 0 }

    break step.next if already_flashed.count == (grid.row_count * grid.column_count)
  end
end

expect(perform(sample_input)).to eq(195)
expect(perform(actual_input)).to eq(494)
