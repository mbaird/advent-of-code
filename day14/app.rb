# frozen_string_literal: true

require 'pry'
require 'rspec'
include RSpec::Matchers

sample_input = <<~HEREDOC
  NNCB

  CH -> B
  HH -> N
  CB -> H
  NH -> C
  HB -> C
  HC -> B
  HN -> C
  NN -> C
  BH -> H
  NC -> B
  NB -> B
  BN -> B
  BB -> N
  BC -> B
  CC -> N
  CN -> C
HEREDOC
actual_input = File.read('input.txt')

# Part 1
def perform(input, steps:)
  lines = input.lines.map(&:strip)
  template = lines.shift.chars
  rules = lines[1..].map { |rule| rule.split(' -> ') }.to_h

  tally = template.each_cons(2).map(&:join).tally
  chars = Hash.new(0)

  template.each do |c|
    chars[c] += 1
  end

  steps.times do
    tally = tally.each_pair.reduce(Hash.new(0)) do |memo, (key, value)|
      to_insert = rules[key]
      chars[to_insert] += value
      [key[0], to_insert, key[1]].each_cons(2).each do |pair|
        memo[pair.join] += value
      end
      memo
    end
  end

  chars.values.max - chars.values.min
end

expect(perform(sample_input, steps: 10)).to eq(1588)
expect(perform(actual_input, steps: 10)).to eq(2027)

expect(perform(sample_input, steps: 40)).to eq(2188189693529)
expect(perform(actual_input, steps: 40)).to eq(2265039461737)
