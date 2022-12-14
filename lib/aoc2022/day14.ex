defmodule AoC2022.Day14 do
  def read_input(path \\ "priv/day14/test.txt") do
    path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_path/1)
    |> Enum.reduce(%{}, &add_path_to_cave/2)
  end

  defp add_path_to_cave(path, cave) do
    path
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.flat_map(&path_points/1)
    |> Enum.reduce(cave, fn p, c ->
      Map.put(c, p, :rock)
    end)
  end

  defp path_points([{x0, y}, {x1, y}]) do
    for x <- min(x0, x1)..max(x0, x1) do
      {x, y}
    end
  end

  defp path_points([{x, y0}, {x, y1}]) do
    for y <- min(y0, y1)..max(y0, y1) do
      {x, y}
    end
  end

  defp parse_path(line) do
    line
    |> String.split(" -> ")
    |> Enum.map(&parse_point/1)
  end

  defp parse_point(string) do
    [x, y] =
      string
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {x, y}
  end

  def part1(path \\ "priv/day14/test.txt") do
    path
    |> read_input()
  end

  def part2(path \\ "priv/day14/test.txt") do
    path
    |> read_input()
  end
end
