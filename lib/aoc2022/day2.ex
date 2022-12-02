defmodule Aoc2022.Day2 do
  @moduledoc """
  https://adventofcode.com/2022/day/2
  """

  defstruct [:opponent, :you]

  def read_input(path \\ "priv/day2/test.txt") do
    path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end

  defp parse_round(line) do
    [opp, you] = String.split(line)
    opp = parse_choice(opp)
    you = parse_choice(you)

    %__MODULE__{
      opponent: opp,
      you: you
    }
  end

  defp parse_round2(line) do
    [opp, result] = String.split(line)
    opp = parse_choice(opp)
    result = parse_result(result)

    you = you_from_result(opp, result)

    %__MODULE__{
      opponent: opp,
      you: you
    }
  end

  defp parse_choice("A"), do: :rock
  defp parse_choice("X"), do: :rock
  defp parse_choice("B"), do: :paper
  defp parse_choice("Y"), do: :paper
  defp parse_choice("C"), do: :scissors
  defp parse_choice("Z"), do: :scissors

  defp parse_result("X"), do: :lose
  defp parse_result("Y"), do: :draw
  defp parse_result("Z"), do: :win

  defp you_from_result(opp, :draw), do: opp
  defp you_from_result(:rock, :lose), do: :scissors
  defp you_from_result(:paper, :lose), do: :rock
  defp you_from_result(:scissors, :lose), do: :paper
  defp you_from_result(:rock, :win), do: :paper
  defp you_from_result(:paper, :win), do: :scissors
  defp you_from_result(:scissors, :win), do: :rock

  defp round_score(%__MODULE__{opponent: opponent, you: you}) do
    outcome_score(you, opponent) + shape_score(you)
  end

  defp outcome_score(a, b) when a == b, do: 3
  defp outcome_score(:rock, :scissors), do: 6
  defp outcome_score(:scissors, :paper), do: 6
  defp outcome_score(:paper, :rock), do: 6
  defp outcome_score(_, _), do: 0

  defp shape_score(:rock), do: 1
  defp shape_score(:paper), do: 2
  defp shape_score(:scissors), do: 3

  def part1(path \\ "priv/day2/input.txt") do
    path
    |> read_input()
    |> Enum.map(&parse_round/1)
    |> Enum.map(&round_score/1)
    |> Enum.sum()
  end

  def part2(path \\ "priv/day2/input.txt") do
    path
    |> read_input()
    |> Enum.map(&parse_round2/1)
    |> Enum.map(&round_score/1)
    |> Enum.sum()
  end
end
