defmodule AoC2022.Day13 do
  def read_input(path \\ "priv/day13/test.txt") do
    path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&empty?/1)
    |> Stream.chunk_every(2)
    |> Stream.map(fn [a, b] ->
      # Parsing shortcut: the input lists are in Elixir syntax so we can use Code.eval_string.
      # Note that this is not safe for arbitrary input.
      {a, []} = Code.eval_string(a)
      {b, []} = Code.eval_string(b)
      {a, b}
    end)
    |> Enum.to_list()
  end

  defp empty?(""), do: true
  defp empty?(s) when is_binary(s), do: false

  def part1(path \\ "priv/day13/test.txt") do
    path
    |> read_input()
    |> Enum.map(fn {a, b} -> in_order(a,b) end)
    |> Enum.with_index(1)
    |> Enum.filter(fn {v, _} -> v end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
  end

  def in_order([a | _], [b | _]) when is_integer(a) and is_integer(b) and a < b do
    true
  end
  def in_order([a | _], [b | _]) when is_integer(a) and is_integer(b) and a > b do
    false
  end
  # This takes care of equal numbers and equal lists as elements.
  def in_order([a | as], [b | bs]) when a == b do
    in_order(as, bs)
  end

  def in_order([a | as], [b | _] = bs) when is_integer(a) and is_list(b) do
    in_order([[a] | as], bs)
  end
  def in_order([a | _] = as, [b | bs]) when is_list(a) and is_integer(b) do
    in_order(as, [[b] | bs])
  end

  def in_order([], [_ | _]), do: true
  def in_order([_ | _], []), do: false
  def in_order([], []), do: :cont

  def in_order([a | as], [b | bs]) do
    case in_order(a, b) do
      :cont -> in_order(as, bs)
      result -> result
    end
  end

  def part2(path \\ "priv/day13/test.txt") do
    signals = path
    |> read_input()
    |> Enum.flat_map(fn {a,b} -> [a,b] end)

    divider_1 = [[2]]
    divider_2 = [[6]]

    sorted = Enum.sort([divider_1, divider_2 | signals], &in_order/2)

    loc_1 = Enum.find_index(sorted, fn x -> x == divider_1 end) + 1
    loc_2 = Enum.find_index(sorted, fn x -> x == divider_2 end) + 1

    loc_1 * loc_2
  end
end
