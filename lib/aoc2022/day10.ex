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

  defmodule Crt do
    def new() do
      []
    end

    def draw_pixel(crt, :lit) do
      [:lit | crt]
    end

    def draw_pixel(crt, :dark) do
      [:dark | crt]
    end

    def render(crt) do
      crt
      |> Enum.reverse()
      |> Enum.map(&pixel_to_string/1)
      |> Enum.chunk_every(40)
      |> Enum.join("\n")
    end

    defp pixel_to_string(:lit), do: "#"
    defp pixel_to_string(:dark), do: "."
  end

  def part2(path \\ "priv/day10/test.txt") do
    states =
      path
      |> read_input()
      |> execute(new_machine())
      |> Enum.to_list()

    max_clock = List.last(states)

    timestamps = 0..(max_clock.clock - 1) |> IO.inspect()

    {crt, _} =
      timestamps
      |> Enum.reduce({Crt.new(), states}, fn ts, {crt, states} ->
        current_state = hd(states)

        new_crt = Crt.draw_pixel(crt, pixel(current_state.x, ts))

        new_states =
          if current_state.clock <= ts do
            tl(states)
          else
            states
          end

        {new_crt, new_states}
      end)

    Crt.render(crt)
  end

  defp pixel(x, ts) do
    scan_pos = rem(ts, 40)

    if abs(x - scan_pos) <= 1 do
      :lit
    else
      :dark
    end
  end
end
