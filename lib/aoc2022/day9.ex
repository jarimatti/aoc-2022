defmodule AoC2022.Day9 do
  def read_input(path \\ "priv/day9/test.txt") do
    path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    [command, amount] = String.split(line)
    {parse_command(command), String.to_integer(amount)}
  end

  defp parse_command("U"), do: :up
  defp parse_command("D"), do: :down
  defp parse_command("L"), do: :left
  defp parse_command("R"), do: :right

  def part1(path \\ "priv/day9/test.txt") do
    initial = {0, 0}

    path
    |> read_input()
    |> Enum.to_list()
    |> head_positions(initial)
    |> tail_positions(initial)
    |> MapSet.new()
    |> MapSet.size()
  end

  def part2(path \\ "priv/day9/test.txt", tail_count \\ 9) do
    initial = {0, 0}

    positions =
      path
      |> read_input()
      |> Enum.to_list()
      |> head_positions(initial)

    1..tail_count
    |> Enum.reduce(positions, fn _, acc ->
      pos = tail_positions(acc, initial)

      pos
    end)
    |> MapSet.new()
    |> MapSet.size()
  end

  def head_positions(moves, initial) do
    head_positions(moves, initial, [initial])
  end

  def head_positions([], _pos, positions) do
    Enum.reverse(positions)
  end

  def head_positions([move | moves], pos, positions) do
    [new_pos | _] = new_positions = apply_move(move, pos)
    head_positions(moves, new_pos, new_positions ++ positions)
  end

  defp apply_move({:up, count}, {x, y}) do
    for c <- count..1, do: {x, y + c}
  end

  defp apply_move({:down, count}, {x, y}) do
    for c <- count..1, do: {x, y - c}
  end

  defp apply_move({:left, count}, {x, y}) do
    for c <- count..1, do: {x - c, y}
  end

  defp apply_move({:right, count}, {x, y}) do
    for c <- count..1, do: {x + c, y}
  end

  def tail_positions(head_positions, initial) do
    tail_positions(head_positions, initial, [initial])
  end

  def tail_positions([], _, positions), do: Enum.reverse(positions)

  def tail_positions([head | rest], current, positions) do
    if should_move(head, current) do
      new_current = move_tail(head, current)
      tail_positions(rest, new_current, [new_current | positions])
    else
      tail_positions(rest, current, positions)
    end
  end

  def should_move({x1, y1}, {x2, y2}) do
    dx = abs(x1 - x2)
    dy = abs(y1 - y2)
    dx > 1 || dy > 1
  end

  def move_tail({x1, y}, {x2, y}) when x1 > x2, do: {x2 + 1, y}
  def move_tail({x1, y}, {x2, y}) when x1 < x2, do: {x2 - 1, y}
  def move_tail({x, y1}, {x, y2}) when y1 > y2, do: {x, y2 + 1}
  def move_tail({x, y1}, {x, y2}) when y1 < y2, do: {x, y2 - 1}
  def move_tail({x1, y1}, {x2, y2}) when x1 > x2 and y1 > y2, do: {x2 + 1, y2 + 1}
  def move_tail({x1, y1}, {x2, y2}) when x1 > x2 and y1 < y2, do: {x2 + 1, y2 - 1}
  def move_tail({x1, y1}, {x2, y2}) when x1 < x2 and y1 < y2, do: {x2 - 1, y2 - 1}
  def move_tail({x1, y1}, {x2, y2}) when x1 < x2 and y1 > y2, do: {x2 - 1, y2 + 1}

  def draw(points, char \\ "#") do
    rows = Enum.map(points, fn {_, y} -> y end)
    cols = Enum.map(points, fn {x, _} -> x end)

    left = Enum.min(cols)
    right = Enum.max(cols)
    top = Enum.max(rows)
    bottom = Enum.min(rows)

    set = MapSet.new(points)

    for r <- top..bottom do
      for c <- left..right do
        if MapSet.member?(set, {c, r}) do
          IO.write(char)
        else
          IO.write(".")
        end
      end

      IO.puts("")
    end

    :ok
  end
end
