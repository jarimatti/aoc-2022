defmodule Aoc2022.Day14Test do
  use ExUnit.Case

  alias AoC2022.Day14

  test "part 1 test input solution is correct" do
    assert(Day14.part1("priv/day14/test.txt") == 24)
  end

  test "part 1 input solution is correct" do
    assert(Day14.part1("priv/day14/input.txt") == 719)
  end

  test "part 2 test input solution is correct" do
    assert(Day14.part2("priv/day14/test.txt") == 93)
  end

  test "part 2 input solution is correct" do
    assert(Day14.part2("priv/day14/input.txt") == 23390)
  end
end
