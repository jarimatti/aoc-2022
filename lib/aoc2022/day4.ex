defmodule AoC2022.Day4 do
  def read_input(path \\ "priv/day4/test.txt") do
    path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_assignments/1)
  end

  def part1(path \\ "priv/day4/input.txt") do
    path
    |> read_input()
    |> Enum.count(&contains_fully?/1)
  end

  def part2(path \\ "priv/day4/input.txt") do
    path
    |> read_input()
    |> Enum.count(&contains_partially?/1)
  end

  defp parse_assignments(line) do
    [a, b] = String.split(line, ",")
    {parse_range(a), parse_range(b)}
  end

  defp parse_range(s) do
    [a, b] =
      s
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    Range.new(a, b)
  end

  defp contains_fully?({%Range{first: a, last: b}, %Range{first: x, last: y}}) do
    (a <= x and b >= y) or (a >= x and b <= y)
  end

  defp contains_partially?({a, b}) do
    not Range.disjoint?(a, b)
  end
end
