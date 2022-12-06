defmodule AoC2022.Day5 do

  def read_input(path \\ "priv/day5/test.txt") do
    {crates, actions} = path
    |> File.stream!()
    |> Stream.map(fn s -> String.trim_trailing(s, "\n") end)
    |> Enum.split_while(fn s -> s != "" end)

    crates = crates
    |> Enum.reduce(%{}, &parse_crate_line/2)
    |> Enum.map(fn {k, v} -> {k, Enum.reverse(v)} end)
    |> Map.new()

    actions = Enum.map(tl(actions), &parse_action/1)

    {crates, actions}
  end

  defp parse_crate_line(" 1 " <> _rest, acc), do: acc
  defp parse_crate_line(s, acc) do
    s
    |> String.codepoints()
    |> Enum.chunk_every(4)
    |> Enum.with_index(1)
    |> parse_crate_line_entries(acc)
  end

  # TODO: Can map to list of lists with :empty, transpose and be done.
  defp parse_crate_line_entries([], acc), do: acc
  defp parse_crate_line_entries([{[" " | _], _index} | rest], acc) do
    parse_crate_line_entries(rest, acc)
  end
  defp parse_crate_line_entries([{["[", crate, "]" | _], index} | rest], acc) do
    new_acc = Map.update(acc, index, [crate], fn s -> [crate | s] end)
    parse_crate_line_entries(rest, new_acc)
  end

  def parse_action(s) do
    ["move", count, "from", from, "to", to] = String.split(s)

    {:move, String.to_integer(count), String.to_integer(from), String.to_integer(to)}
  end

  def part1(path \\ "priv/day5/test.txt") do
    {stacks, program} = read_input(path)

    program
    |> run_program(stacks, &execute_instruction/2)
    |> to_output()
  end

  defp run_program(program, stacks, execute) do
    Enum.reduce(program, stacks, execute)
  end

  defp execute_instruction({:move, count, from, to}, stack) do
    {crates, stack} = Map.get_and_update!(stack, from, fn crates ->
      {Enum.take(crates, count), Enum.drop(crates, count)}
    end)
    Map.update(stack, to, crates, fn cs -> Enum.reverse(crates) ++ cs end)
  end

  defp execute_instruction2({:move, count, from, to}, stack) do
    {crates, stack} = Map.get_and_update!(stack, from, fn crates ->
      {Enum.take(crates, count), Enum.drop(crates, count)}
    end)
    Map.update(stack, to, crates, fn cs -> crates ++ cs end)
  end

  defp to_output(map) do
    map
    |> Enum.to_list()
    |> Enum.sort()
    |> Enum.map(fn {_, l} -> hd(l) end)
    |> Enum.join()
  end

  def part2(path \\ "priv/day5/test.txt") do
    {stacks, program} = read_input(path)

    program
    |> run_program(stacks, &execute_instruction2/2)
    |> to_output()
  end

end
