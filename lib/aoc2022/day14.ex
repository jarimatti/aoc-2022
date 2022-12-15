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

  def drop_all_sand(cave, c \\ 10) do
    drop_all_sand(cave, start_pos(), extents(cave), c)
  end

  def drop_all_sand(cave, _start, _e, 0) do
    {:error, :limit, cave}
  end

  def drop_all_sand(cave, start, e, c) do
    case drop_one_sand(cave, start, e) do
      {:cont, cave} -> drop_all_sand(cave, start, e, c - 1)
      {:halt, cave} -> cave
    end
  end

  defp drop_one_sand(cave, {x, y} = pos, {{min_x, _}, {max_x, max_y}} = e)
       when x in min_x..max_x and y <= max_y do
    case maybe_move(cave, pos) do
      {:cont, new_pos} ->
        drop_one_sand(cave, new_pos, e)

      {:halt, pos} ->
        check_and_put(cave, pos, e)
    end
  end

  defp drop_one_sand(cave, _pos, _e) do
    {:halt, cave}
  end

  def check_and_put(cave, {500, 0} = pos, _) do
    {:halt, Map.put(cave, pos, :sand)}
  end

  def check_and_put(cave, {x, y} = pos, {{min_x, _}, {max_x, max_y}})
      when x in min_x..max_x and y <= max_y do
    {:cont, Map.put(cave, pos, :sand)}
  end

  def check_and_put(cave, _, _) do
    {:halt, cave}
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
    |> drop_all_sand(10_000)
    |> count_sand()
  end

  def part2(path \\ "priv/day14/test.txt") do
    path
    |> read_input()
    |> add_bottom()
    |> drop_all_sand(50_000)
    |> count_sand()
  end

  defp count_sand(cave) do
    Enum.count(cave, fn {_k, v} -> v == :sand end)
  end

  defp add_bottom(cave) do
    {{min_x, min_y}, {max_x, max_y}} = extents(cave)

    floor_y = max_y + 2
    height = max_y - min_y

    min_x = min_x - height - 10
    max_x = max_x + height + 10

    Enum.reduce(min_x..max_x, cave, fn x, c ->
      Map.put(c, {x, floor_y}, :rock)
    end)
  end
end
