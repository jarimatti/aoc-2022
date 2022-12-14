defmodule AoC2022.Day14 do
  def read_input(path \\ "priv/day14/test.txt") do
    cave =
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&parse_path/1)
      |> Enum.reduce(%{}, &add_path_to_cave/2)

    Map.put(cave, start_pos(), :start)
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

  def cave_to_string(cave) do
    {{min_x, min_y}, {max_x, max_y}} = extents(cave)

    Enum.map(min_y..max_y, fn y ->
      Enum.map(
        min_x..max_x,
        fn x ->
          case Map.get(cave, {x, y}, :empty) do
            :empty -> "."
            :rock -> "#"
            :sand -> "o"
            :start -> "+"
          end
        end
      )
    end)
    |> Enum.join("\n")
  end

  def extents(cave) do
    points = Map.keys(cave)

    {min_x, max_x} =
      points
      |> Enum.map(fn {x, _} -> x end)
      |> Enum.min_max()

    {min_y, max_y} =
      points
      |> Enum.map(fn {_, y} -> y end)
      |> Enum.min_max()

    top_left = {min_x, min_y}
    bottom_right = {max_x, max_y}

    {top_left, bottom_right}
  end

  def start_pos(), do: {500, 0}

  def drop_sand(cave) do
    start = start_pos()

    drop_sand(cave, start)
  end

  defp drop_sand(cave, pos) do
    case maybe_move(cave, pos) do
      {:cont, new_pos} -> drop_sand(cave, new_pos)
      {:halt, pos} -> Map.put(cave, pos, :sand)
    end
  end

  defp maybe_move(cave, pos) do
    [&down/1, &down_left/1, &down_right/1]
    |> Enum.map(fn f -> is_free(cave, f.(pos)) end)
    |> Enum.find({:halt, pos}, fn x -> x end)
  end

  defp down({x, y}), do: {x, y + 1}
  defp down_left({x, y}), do: {x - 1, y + 1}
  defp down_right({x, y}), do: {x + 1, y + 1}

  defp is_free(cave, pos) do
    case Map.get(cave, pos) do
      nil -> {:cont, pos}
      :rock -> false
      :sand -> false
    end
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
