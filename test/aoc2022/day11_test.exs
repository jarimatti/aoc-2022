defmodule Aoc2022.Day11Test do
  use ExUnit.Case

  alias AoC2022.Day11

  test "part 1 test input solution is correct" do
    assert(Day11.part1("priv/day11/test.txt") == 10605)
  end

  test "part 1 input solution is correct" do
    assert(Day11.part1("priv/day11/input.txt") == 69918)
  end

  test "part 2 test input solution is correct" do
    assert(Day11.part2("priv/day11/test.txt", 10000) == 2_713_310_158)
  end

  test "part 2 input solution is correct" do
    assert(Day11.part2("priv/day11/input.txt", 10000) == 19_573_408_701)
  end
end
