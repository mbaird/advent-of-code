# frozen_string_literal: true

require 'pry'
require 'rspec'
include RSpec::Matchers

sample_input = "3,4,3,1,2"
actual_input = File.read('input.txt')

def perform(input, count: 80)
  ages = input.split(',').map(&:to_i)
  tally = Array.new(9) { |i| ages.count(i) }

  count.times do
    created = tally.shift
    tally[8] = created
    tally[6] += created
  end

  tally.sum
end

expect(perform(sample_input, count: 18)).to eq(26)
expect(perform(sample_input, count: 80)).to eq(5934)
expect(perform(actual_input, count: 80)).to eq(363101)
expect(perform(sample_input, count: 256)).to eq(26984457539)
expect(perform(actual_input, count: 256)).to eq(1644286074024)
