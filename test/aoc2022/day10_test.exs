defmodule Aoc2022.Day10Test do
  use ExUnit.Case

  alias AoC2022.Day10

  test "part 1 test input solution is correct" do
    assert(Day10.part1("priv/day10/test.txt") == 13140)
  end

  test "part 1 input solution is correct" do
    assert(Day10.part1("priv/day10/input.txt") == 14520)
  end
end
