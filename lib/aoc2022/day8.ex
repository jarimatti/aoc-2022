defmodule AoC2022.Day8 do
  def read_input(path \\ "priv/day8/test.txt") do
    {max_row, max_col, map} =
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> parse_map()

    {{0..(max_row - 1), 0..(max_col - 1)}, map}
  end

  defp parse_map(lines) do
    Enum.reduce(lines, {0, 0, %{}}, &parse_line/2)
  end

  defp parse_line(line, {row, _, map}) do
    {col, new_map} =
      line
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce({0, map}, fn x, {col, map} ->
        {col + 1, Map.put(map, {row, col}, x)}
      end)

    {row + 1, col, new_map}
  end

  def part1(path \\ "priv/day8/test.txt") do
    path
    |> read_input()
    |> visible_trees()
    |> MapSet.size()
  end

  defp visible_trees({{row_range, col_range}, map}) do
    # Go through rows and grab visible trees.
    row_set =
      Enum.reduce(row_range, MapSet.new(), fn row, set ->
        {_, new_set} =
          Enum.reduce(col_range, {-1, set}, fn col, {prev, set} ->
            visible_step(row, col, prev, map, set)
          end)

        new_set
      end)

    row_set =
      Enum.reduce(row_range, row_set, fn row, set ->
        {_, new_set} =
          Enum.reduce(Enum.reverse(col_range), {-1, set}, fn col, {prev, set} ->
            visible_step(row, col, prev, map, set)
          end)

        new_set
      end)

    # Go through columns and grab visible trees.
    col_set =
      Enum.reduce(col_range, row_set, fn col, set ->
        {_, new_set} =
          Enum.reduce(row_range, {-1, set}, fn row, {prev, set} ->
            visible_step(row, col, prev, map, set)
          end)

        new_set
      end)

    Enum.reduce(col_range, col_set, fn col, set ->
      {_, new_set} =
        Enum.reduce(Enum.reverse(row_range), {-1, set}, fn row, {prev, set} ->
          visible_step(row, col, prev, map, set)
        end)

      new_set
    end)
  end

  defp visible_step(row, col, prev, map, set) do
    tree = Map.get(map, {row, col})

    new_set =
      if tree > prev do
        MapSet.put(set, {row, col})
      else
        set
      end

    {max(tree, prev), new_set}
  end

  def part2(path \\ "priv/day8/test.txt") do
    {{row_range, col_range}, map} = read_input(path)

    all_points = for row <- row_range, col <- col_range, do: {row, col}

    all_points
    |> Enum.map(fn p -> scenic_score(p, {row_range, col_range}, map) end)
    |> Enum.max()
  end

  def scenic_score({row, col}, {row_range, col_range}, map) do
    height = Map.get(map, {row, col})

    points_north = Enum.reverse(for r <- row_range, r < row, do: {r, col})
    points_south = for r <- row_range, r > row, do: {r, col}
    points_west = Enum.reverse(for c <- col_range, c < col, do: {row, c})
    points_east = for c <- col_range, c > col, do: {row, c}

    [points_north, points_south, points_west, points_east]
    |> Enum.map(fn r -> visible_range(height, r, map) end)
    |> Enum.product()
  end

  def visible_range(_height, [], _map), do: 0

  def visible_range(height, points, map) do
    points
    |> Enum.map(fn p -> Map.get(map, p) end)
    |> Enum.reduce_while(0, fn
      t, count when t >= height -> {:halt, count + 1}
      _t, count -> {:cont, count + 1}
    end)
  end
end
