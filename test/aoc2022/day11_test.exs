defmodule Aoc2022.Day11Test do
  use ExUnit.Case

  alias AoC2022.Day11

  test "part 1 test input solution is correct" do
    assert(Day11.part1("priv/day11/test.txt") == 10605)
  end

  # test "part 1 input solution is correct" do
  #   assert(Day11.part1("priv/day11/input.txt") == 14520)
  # end
end
