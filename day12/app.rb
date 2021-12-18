# frozen_string_literal: true

require 'pry'
require 'rspec'
include RSpec::Matchers

sample_input = <<~HEREDOC
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
HEREDOC
actual_input = File.read('input.txt')

Node = Struct.new(:key, :links) do
  def add_link(link)
    self.links << link
  end

  def can_visit?(path)
    !start? && (uppercase? || first_visit?(path))
  end

  def first_visit?(path)
    !path.include?(key)
  end

  def uppercase?
    key == key.upcase
  end

  def start?
    key == 'start'
  end

  def end?
    key == 'end'
  end
end

NodeV2 = Class.new(Node) do
  def can_visit?(path)
    !start? && (uppercase? || first_visit?(path) || !duplicate_small_cave?(path))
  end

  def duplicate_small_cave?(path)
    path.select { |a| a.upcase != a }.tally.values.max > 1
  end
end

def traverse(nodes, paths)
  loop do
    paths = paths.reduce([]) { |memo, path|
      node = nodes[path.last]

      next memo << path if node.end?

      node.links.each { |link|
        memo << (path.dup << link) if nodes[link].can_visit?(path)
      }

      memo
    }

    break paths if paths.all? { |path| nodes[path.last].end? }
  end
end

def perform(input, klass: Node)
  nodes = input.lines.map(&:strip).reduce({}) do |memo, line|
    connection = line.split('-')
    a, b = connection

    memo[a] ||= klass.new(a, [])
    memo[b] ||= klass.new(b, [])

    memo[a].add_link(b)
    memo[b].add_link(a)

    memo
  end

  traverse(nodes, [['start']]).count
end

expect(perform(sample_input)).to eq(10)
expect(perform(actual_input)).to eq(3495)

expect(perform(sample_input, klass: NodeV2)).to eq(36)
expect(perform(actual_input, klass: NodeV2)).to eq(94849)
