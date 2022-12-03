defmodule Mix.Tasks.NewDay do
  @moduledoc """
  Generate new day directories and stub module.
  """

  @shortdoc "New AoC day directories"

  use Mix.Task

  require Mix.Generator

  @impl Mix.Task
  def run(args) do
    [day] = args
    day = String.to_integer(day)

    Mix.shell().info("Creating directories for Advent of Code day #{day}")
    create_input_directory(day)
    create_module(day)
  end

  defp create_input_directory(day) do
    Mix.Generator.create_directory(Path.join(["priv", "day#{day}"]))
  end

  defp create_module(day) do
    data = module_template(%{day: day})
    path = Path.join(["lib", "aoc2022", "day#{day}.ex"])
    Mix.Generator.create_file(path, data)
  end

  Mix.Generator.embed_template(:module,
  """
  defmodule AoC2022.Day<%= @day %> do

    def read_input(path \\\\ "priv/day<%= @day %>/test.txt") do
      path
      |> File.stream!()
      |> Enum.map(&String.trim/1)
    end

    def part1(path \\\\ "priv/day<%= @day %>/test.txt") do
      path
      |> read_input()
    end

    def part2(path \\\\ "priv/day<%= @day %>/test.txt") do
      path
      |> read_input()
    end

  end
  """)
end
