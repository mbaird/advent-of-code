# frozen_string_literal: true

require 'pry'
require 'rspec'
include RSpec::Matchers

sample_input = <<~HEREDOC
  [({(<(())[]>[[{[]{<()<>>
  [(()[<>])]({[<{<<[]>>(
  {([(<{}[<>[]}>{[]{[(<()>
  (((({<>}<{<{<>}{[]{[]{}
  [[<[([]))<([[{}[[()]]]
  [{[{({}]{}}([{[{{{}}([]
  {<[[]]>}<{[{[{[]{()[[[]
  [<(<(<(<{}))><([]([]()
  <{([([[(<>()){}]>(<<{{
  <{([{{}}[<[[[<>{}]]]>[]]
HEREDOC
actual_input = File.read('input.txt')

OPEN_MAP = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }
CLOSE_MAP = OPEN_MAP.invert

# Part 1
def perform(input)
  scores = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }
  rows = input.lines.map(&:strip).map(&:chars)

  rows.reduce(0) do |score, row|
    closes = []

    found = row.each do |bracket|
      if OPEN_MAP.keys.include?(bracket)
        closes.unshift(OPEN_MAP[bracket])
      else
        break bracket if closes.shift != bracket
      end
    end

    score + (scores[found] || 0)
  end
end

expect(perform(sample_input)).to eq(26397)
expect(perform(actual_input)).to eq(374061)

# Part 2
def perform(input)
  scores = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }
  rows = input.lines.map(&:strip).map(&:chars)

  scores = rows.map do |row|
    closes = row.reduce([]) do |memo, bracket|
      if OPEN_MAP.keys.include?(bracket)
        memo.unshift(OPEN_MAP[bracket])
      else
        break [] if memo.shift != bracket
      end

      memo
    end

    next nil if closes.empty?

    closes.reduce(0) { |score, bracket|
      (score * 5) + scores[bracket]
    }
  end

  scores.compact.sort[scores.compact.length / 2]
end

expect(perform(sample_input)).to eq(288957)
expect(perform(actual_input)).to eq(2116639949)
