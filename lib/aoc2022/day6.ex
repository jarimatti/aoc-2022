defmodule AoC2022.Day6 do
  def read_input(path \\ "priv/day6/input.txt") do
    path
    |> File.read!()
    |> String.trim()
  end

  def part1(path \\ "priv/day6/input.txt") do
    path
    |> read_input()
    |> first_marker_at()
  end

  def part2(path \\ "priv/day6/input.txt") do
    path
    |> read_input()
    |> first_message_at()
  end

  def first_marker_at(s) when is_binary(s) do
    s
    |> String.to_charlist()
    |> first_marker_at(0, 4)
  end

  def first_message_at(s) when is_binary(s) do
    s
    |> String.to_charlist()
    |> first_marker_at(0, 14)
  end

  defp first_marker_at(string, index, size) do
    s =
      string
      |> Enum.take(size)
      |> MapSet.new()
      |> MapSet.size()

    case s do
      ^size -> index + size
      _ -> first_marker_at(tl(string), index + 1, size)
    end
  end
end
