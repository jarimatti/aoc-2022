defmodule Aoc2022.Day15Test do
  use ExUnit.Case

  alias AoC2022.Day15

  test "part 1 test input solution is correct" do
    assert(Day15.part1(10, "priv/day15/test.txt") == 26)
  end

  test "part 1 input solution is correct" do
    assert(Day15.part1(2_000_000, "priv/day15/input.txt") == 5_144_286)
  end

  test "part 2 test input solution is correct" do
    assert(Day15.part2(0..20, "priv/day15/test.txt") == 56_000_011)
  end

  test "part 2 input solution is correct" do
    assert(AoC2022.Day15.part2(0..4_000_000, "priv/day15/input.txt") == 10_229_191_267_339)
  end
end
