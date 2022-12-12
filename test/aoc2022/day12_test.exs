defmodule Aoc2022.Day12Test do
  use ExUnit.Case

  alias AoC2022.Day12

  test "part 1 test input solution is correct" do
    assert(Day12.part1("priv/day12/test.txt") == {:ok, 31})
  end

  test "part 1 test input solution can descent and ascent" do
    assert(Day12.part1("priv/day12/test.descent.txt") == {:ok, 34})
  end

  test "part 1 input solution is correct" do
    assert(Day12.part1("priv/day12/input.txt") == {:ok, 484})
  end

  # test "part 2 test input solution is correct" do
  #   assert(Day12.part2("priv/day12/test.txt") == {:ok, 29})
  # end
end
