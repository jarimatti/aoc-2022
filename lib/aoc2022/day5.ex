defmodule AoC2022.Day5 do

  def read_input(path \\ "priv/day5/test.txt") do
    path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end

  def part1(path \\ "priv/day5/test.txt") do
    path
    |> read_input()
  end

  def part2(path \\ "priv/day5/test.txt") do
    path
    |> read_input()
  end

end
