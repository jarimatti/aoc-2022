defmodule Aoc2022.Day13Test do
  use ExUnit.Case

  alias AoC2022.Day13

  test "part 1 test input solution is correct" do
    assert(Day13.part1("priv/day13/test.txt") == 13)
  end

  test "part 1 input solution is correct" do
    assert(Day13.part1("priv/day13/input.txt") == 5330)
  end

  test "part 2 test input solution is correct" do
    assert(Day13.part2("priv/day13/test.txt") == 140)
  end

  test "part 2 input solution is correct" do
    assert(Day13.part2("priv/day13/input.txt") == 27648)
  end
end
