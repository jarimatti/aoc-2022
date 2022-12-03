defmodule AoC2022.Day3 do

  def read_input(path \\ "priv/day3/test.txt") do
    path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end

  def part1(path \\ "priv/day3/input.txt") do
    path
    |> read_input()
    |> Enum.map(&parse_rucksack/1)
    |> Enum.map(fn {a, b} -> MapSet.intersection(a, b) end)
    |> Enum.map(&item_score/1)
    |> Enum.sum()
  end

  def part2(path \\ "priv/day3/input.txt") do
    path
    |> read_input()
    |> Enum.chunk_every(3)
    |> Enum.map(fn xs -> Enum.map(xs, &parse_container/1) end)
    |> Enum.map(fn [a, b, c] ->
      a
      |> MapSet.intersection(b)
      |> MapSet.intersection(c)
    end)
    |> Enum.map(&item_score/1)
    |> Enum.sum()
  end

  defp parse_rucksack(line) do
    len = String.length(line)
    {first, second} = String.split_at(line, div(len, 2))

    {parse_container(first), parse_container(second)}
  end

  defp parse_container(string) do
    string
    |> String.codepoints()
    |> MapSet.new()
  end

  defp item_score(item) do
    [is] = MapSet.to_list(item)
    [c] = String.to_charlist(is)

    case c >= ?a do
      true -> c - ?a + 1
      false -> c - ?A + 27
    end
  end

end
