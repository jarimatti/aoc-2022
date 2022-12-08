defmodule Aoc2022.Day8Test do
  use ExUnit.Case

  alias AoC2022.Day8

  test "part 1 test input solution is correct" do
    assert(Day8.part1("priv/day8/test.txt") == 21)
  end

  test "part 1 solution is correct" do
    assert(Day8.part1("priv/day8/input.txt") == 1785)
  end

  test "part 2 test input solution is correct" do
    assert(Day8.part2("priv/day8/test.txt") == 8)
  end

  test "part 2 solution is correct" do
    assert(Day8.part2("priv/day8/input.txt") == 345_168)
  end
end
