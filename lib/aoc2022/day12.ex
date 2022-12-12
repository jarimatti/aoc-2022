defmodule AoC2022.Day12 do
  def read_input(path \\ "priv/day12/test.txt") do
    path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.with_index()
    |> Enum.reduce(%{}, &parse_line/2)
  end

  defp parse_line({line, row}, map) do
    line
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.reduce(map, fn {c, col}, m ->
      Map.put(m, {row, col}, parse_char(c))
    end)
  end

  defp parse_char(?S), do: :start
  defp parse_char(?E), do: :end
  defp parse_char(c), do: c - ?a

  def to_graph(map) do
    points = Map.keys(map)

    graph = :digraph.new([:cyclic, :private])

    Enum.each(points, fn {r, c} = p ->
      connect(map, graph, p, {r + 1, c})
      connect(map, graph, p, {r, c + 1})
    end)

    graph
  end

  defp point_value(:start), do: 0
  defp point_value(:end), do: ?z - ?a
  defp point_value(x), do: x

  defp connect(map, graph, a, b) do
    xa = point_value(Map.get(map, a))

    case point_value(Map.get(map, b, nil)) do
      nil -> :ok

      xb when abs(xb-xa) <= 1 ->
        va = :digraph.add_vertex(graph, a)
        vb = :digraph.add_vertex(graph, b)
        :digraph.add_edge(graph, va, vb)
        :digraph.add_edge(graph, vb, va)
        :ok

      xb when xb < xa ->
        va = :digraph.add_vertex(graph, a)
        vb = :digraph.add_vertex(graph, b)
        :digraph.add_edge(graph, va, vb)
        :ok

      _ ->
        :ok
    end
  end

  def part1(path \\ "priv/day12/test.txt") do
    map = read_input(path)
    graph = to_graph(map)

    p_start =
      Enum.find_value(map, fn
        {p, :start} -> p
        _ -> nil
      end)

    p_end =
      Enum.find_value(map, fn
        {p, :end} -> p
        _ -> nil
      end)

    case :digraph.get_short_path(graph, p_start, p_end) do
      false -> {:error, :no_path_found, {map, graph, p_start, p_end}}
      path -> {:ok, length(path) - 1}
    end
  end

  def part2(path \\ "priv/day12/test.txt") do
    path
    |> read_input()
  end
end
