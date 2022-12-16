defmodule AoC2022.Day15 do
  def read_input(path \\ "priv/day15/test.txt") do
    all =
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&parse_sensor_and_beacon/1)
      |> Enum.to_list()

    sensors = Enum.map(all, fn {s, _} -> s end)
    beacons = Enum.map(all, fn {_, b} -> b end)

    min_x =
      all
      |> Enum.map(fn {{{s_x, _}, r}, {b_x, _}} -> min(s_x - r, b_x) end)
      |> Enum.min()

    max_x =
      all
      |> Enum.map(fn {{{s_x, _}, r}, {b_x, _}} -> max(s_x + r, b_x) end)
      |> Enum.max()

    min_y =
      all
      |> Enum.map(fn {{{_, s_y}, r}, {_, b_y}} -> min(s_y - r, b_y) end)
      |> Enum.min()

    max_y =
      all
      |> Enum.map(fn {{{_, s_y}, r}, {_, b_y}} -> max(s_y + r, b_y) end)
      |> Enum.min()

    extents = {{min_x, min_y}, {max_x, max_y}}

    {sensors, beacons, extents}
  end

  def parse_sensor_and_beacon(line) do
    %{"s_x" => s_x, "s_y" => s_y, "b_x" => b_x, "b_y" => b_y} =
      Regex.named_captures(
        ~r/Sensor at x=(?<s_x>-?\d+), y=(?<s_y>\d+): closest beacon is at x=(?<b_x>-?\d+), y=(?<b_y>-?\d+)/,
        line
      )

    s_x = String.to_integer(s_x)
    s_y = String.to_integer(s_y)
    b_x = String.to_integer(b_x)
    b_y = String.to_integer(b_y)

    sensor = {s_x, s_y}
    beacon = {b_x, b_y}
    r = manhattan_distance({s_x, s_y}, {b_x, b_y})

    {{sensor, r}, beacon}
  end

  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def part1(row, path \\ "priv/day15/test.txt") do
    {sensors, beacons, _extent} = read_input(path)

    interesting_sensors = sensors_that_see_row(sensors, row)

    ranges =
      interesting_sensors
      |> Enum.map(fn s -> sensor_range_on_row(s, row) end)
      |> merge_ranges()

    beacons_on_row =
      beacons
      |> MapSet.new()
      |> Enum.filter(fn {_, y} -> row == y end)
      |> Enum.map(fn {x, _} -> x end)

    sensors_on_row =
      sensors
      |> Enum.filter(fn {{_, y}, _} -> row == y end)
      |> Enum.map(fn {{x, _}, _} -> x end)

    Enum.reduce(ranges, 0, fn r, acc ->
      bs = Enum.count(beacons_on_row, fn b -> b in r end)
      ss = Enum.count(sensors_on_row, fn s -> s in r end)

      acc + (Range.size(r) - bs - ss)
    end)
  end

  defp merge_ranges(ranges) do
    ranges
    |> Enum.sort()
    |> Enum.reduce([], fn
      r, [] ->
        [r]

      r, [h | rest] ->
        case Range.disjoint?(r, h) do
          true -> [r, h | rest]
          false -> [merge(r, h) | rest]
        end
    end)
  end

  defp merge(%Range{first: f1, last: l1}, %Range{first: f2, last: l2}) do
    Range.new(min(f1, f2), max(l1, l2))
  end

  defp sensors_that_see_row(sensors, row) do
    Enum.filter(sensors, fn {{_, s_y}, r} ->
      row <= s_y + r and row >= s_y - r
    end)
  end

  def sensor_range_on_row({{x, y}, r}, row) do
    dy = abs(row - y)
    dx = r - dy

    Range.new(x - dx, x + dx)
  end

  def count_common_points(range, ranges) do
    range
    |> Enum.map(fn x ->
      Enum.any?(ranges, fn r -> Enum.member?(r, x) end)
    end)
    |> Enum.count()
  end

  def part2(path \\ "priv/day15/test.txt") do
    path
    |> read_input()
  end
end
