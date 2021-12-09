# frozen_string_literal: true

require 'set'
require 'pry'
require 'rspec'
include RSpec::Matchers

sample_input = <<~HEREDOC
  be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
  edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
  fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
  fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
  aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
  fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
  dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
  bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
  egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
  gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
HEREDOC
actual_input = File.read('input.txt')

# Part 1
def perform(input)
  input
    .lines
    .flat_map { |line| line.split(' | ')[1].split }
    .count { |digit|
      [2, 3, 4, 7].include?(digit.length)
    }
end

expect(perform(sample_input)).to eq(26)
expect(perform(actual_input)).to eq(412)

# Part 2
def perform(input)
  lines = input.lines.map { |line| line.split(' | ').map(&:split) }

  lines.sum { |line|
    patterns, output = line.map { |part| part.map { |pattern| Set[*pattern.chars] } }

    lengths = patterns.group_by(&:length)

    one = lengths[2][0]
    four = lengths[4][0]
    seven = lengths[3][0]
    eight = lengths[7][0]

    zero_six_nine = lengths[6]
    zero = zero_six_nine.find { |set| (set & (four - one)).count == 1 }
    six = zero_six_nine.find { |set| (set & one).count == 1 }
    nine = zero_six_nine.find { |set| (set & four).count == 4 }

    two_three_five = lengths[5]
    two = two_three_five.find { |set| (set & four & six).count == 1 }
    three = two_three_five.find { |set| (set & four & six).count == 2 }
    five = two_three_five.find { |set| (set & four & six).count == 3 }

    mapping = {
      zero => 0,
      one => 1,
      two => 2,
      three => 3,
      four => 4,
      five => 5,
      six => 6,
      seven => 7,
      eight => 8,
      nine => 9
    }

    output.map { |digit| mapping[digit] }.join.to_i
  }
end

expect(perform(sample_input)).to eq(61229)
expect(perform(actual_input)).to eq(978171)
