defmodule AoC2022.Day10 do
  def read_input(path \\ "priv/day10/test.txt") do
    path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_op/1)
  end

  defp parse_op("noop"), do: :noop

  defp parse_op("addx " <> rest) do
    {:addx, String.to_integer(rest)}
  end

  def new_machine() do
    %{
      x: 1,
      clock: 1
    }
  end

  def apply_instruction(machine, :noop) do
    %{machine | clock: machine.clock + 1}
  end

  def apply_instruction(machine, {:addx, amount}) do
    %{machine | clock: machine.clock + 2, x: machine.x + amount}
  end

  def execute(instructions, machine) do
    Stream.concat(
      [machine],
      Stream.scan(instructions, machine, fn op, m -> apply_instruction(m, op) end)
    )
  end

  def part1(path \\ "priv/day10/test.txt") do
    states =
      path
      |> read_input()
      |> execute(new_machine())
      |> Enum.to_list()

    max_clock = List.last(states)

    timestamps = 20..max_clock.clock//40

    {values, _} =
      timestamps
      |> Enum.reduce({[], states}, fn ts, {xs, sts} ->
        [s | _] = rest = Enum.drop_while(sts, fn %{clock: c} -> c < ts - 1 end)

        {[Map.put(s, :at, ts) | xs], rest}
      end)

    values
    |> Enum.map(fn s -> s.at * s.x end)
    |> Enum.sum()
  end

  def part2(path \\ "priv/day10/test.txt") do
    path
    |> read_input()
  end
end
