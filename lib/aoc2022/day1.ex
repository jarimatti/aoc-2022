defmodule Aoc2022.Day1 do
  @moduledoc """
  https://adventofcode.com/2022/day/1
  """

  @type elf() :: [non_neg_integer()]

  def read_input(path \\ "priv/day1/test.txt") do
    path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_while(
      [],
      fn
        "", acc -> {:cont, acc, []}
        e, acc -> {:cont, [e | acc]}
      end,
      fn acc -> {:cont, acc, []} end
    )
    |> Enum.map(&parse_numbers/1)
    |> Enum.to_list()
  end

  defp parse_numbers(list) do
    Enum.map(list, &String.to_integer/1)
  end

  def part1(path \\ "priv/day1/input.txt") do
    elves = read_input(path)

    elves
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  def part2(path \\ "priv/day1/input.txt") do
    elves = read_input(path)

    elves
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
