defmodule AoC2022.Day11 do
  defmodule Operation do
    def parse(string) do
      # Warning: This is not recommended for untrusted input.
      {f, []} = Code.eval_string("fn old -> " <> string <> " end")
      f
    end
  end

  defmodule Test do
    defstruct [:divisible_by, true, false]

    def new(divisible_by, t, f) do
      %__MODULE__{divisible_by: divisible_by, true: t, false: f}
    end

    def eval(%__MODULE__{divisible_by: d, true: t}, worry) when rem(worry, d) == 0, do: t
    def eval(%__MODULE__{false: f}, _worry), do: f
  end

  defmodule Monkey do
    defstruct [:id, :items, :operation, :test, :inspection_count]

    def new(id, operation, test) do
      %__MODULE__{id: id, items: [], operation: operation, test: test, inspection_count: 0}
    end

    def receive_item(%__MODULE__{items: items} = monkey, item) do
      %__MODULE__{monkey | items: [item | items]}
    end

    def turn_part1(%__MODULE__{} = m, monkeys) do
      new_monkeys =
        m.items
        |> Enum.reverse()
        |> Enum.reduce(monkeys, fn item, monkeys ->
          worry = div(m.operation.(item), 3)
          next_monkey = Test.eval(m.test, worry)

          Map.update!(monkeys, next_monkey, fn nm ->
            receive_item(nm, worry)
          end)
        end)

      Map.update!(new_monkeys, m.id, fn m ->
        %__MODULE__{m | items: [], inspection_count: m.inspection_count + length(m.items)}
      end)
    end
  end

  def read_input(path \\ "priv/day11/test.txt") do
    path
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> parse_monkeys()
  end

  defp parse_monkeys(stream) do
    stream
    |> Stream.chunk_by(fn s -> s == "" end)
    |> Stream.reject(fn x -> x == [""] end)
    |> Stream.map(&parse_monkey/1)
  end

  defp parse_monkey([id_line, item_line, op_line | rest]) do
    id = parse_id(id_line)
    items = parse_items(item_line)
    op = parse_operation(op_line)
    test = parse_test(rest)

    Enum.reduce(
      items,
      Monkey.new(id, op, test),
      fn i, m -> Monkey.receive_item(m, i) end
    )
  end

  defp parse_operation("  Operation: new = " <> rest) do
    Operation.parse(rest)
  end

  defp parse_test([
         "  Test: divisible by " <> d,
         "    If true: throw to monkey " <> tm,
         "    If false: throw to monkey " <> fm
       ]) do
    Test.new(
      String.to_integer(d),
      String.to_integer(tm),
      String.to_integer(fm)
    )
  end

  defp parse_id("Monkey " <> rest) do
    {id, ":"} = Integer.parse(rest)
    id
  end

  defp parse_items("  Starting items: " <> rest) do
    rest
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
  end

  def part1(path \\ "priv/day11/test.txt") do
    monkeys =
      path
      |> read_input()
      |> Enum.to_list()
      |> Map.new(fn m -> {m.id, m} end)

    ids =
      monkeys
      |> Map.keys()
      |> Enum.sort()

    final_monkeys =
      Enum.reduce(1..20, monkeys, fn _, ms ->
        Enum.reduce(ids, ms, fn id, ms ->
          m = Map.get(ms, id)
          Monkey.turn_part1(m, ms)
        end)
      end)

    final_monkeys
    |> Enum.map(fn {_, m} -> m.inspection_count end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def part2(path \\ "priv/day11/test.txt") do
    path
    |> read_input()
  end
end
