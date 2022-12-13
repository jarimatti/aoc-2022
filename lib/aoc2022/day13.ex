defmodule AoC2022.Day13 do
  def read_input(path \\ "priv/day13/test.txt") do
    path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  def part1(path \\ "priv/day13/test.txt") do
    path
    |> read_input()
  end

  def part2(path \\ "priv/day13/test.txt") do
    path
    |> read_input()
  end
end
