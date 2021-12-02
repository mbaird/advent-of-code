# frozen_string_literal: true

require 'rspec'
include RSpec::Matchers

sample_input = <<~SAMPLE
  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
SAMPLE
actual_input = File.read('input.txt').split

# Part 1
def perform(input)
end

expect(perform(sample_input)).to eq(150)
# expect(perform(actual_input)).to eq(0)
