defmodule AoC2022.Day7 do
  def read_input(path \\ "priv/day7/test.txt") do
    {tree, _} =
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.reduce({%{}, []}, &parse_line/2)

    tree
  end

  defp parse_line("$ cd /", {tree, _path}) do
    {tree, []}
  end

  defp parse_line("$ cd ..", {tree, []}) do
    {tree, []}
  end

  defp parse_line("$ cd ..", {tree, path}) do
    {tree, Enum.drop(path, -1)}
  end

  defp parse_line("$ cd " <> dir, {tree, path}) do
    {tree, path ++ [dir]}
  end

  defp parse_line("$ ls", {tree, path}) do
    {tree, path}
  end

  defp parse_line("dir " <> dir, {tree, path}) do
    new_tree = put_in(tree, path ++ [dir], %{})

    {new_tree, path}
  end

  defp parse_line(size_file, {tree, path}) do
    [size, file] = String.split(size_file)
    size = String.to_integer(size)

    new_tree = put_in(tree, path ++ [file], size)

    {new_tree, path}
  end

  def part1(path \\ "priv/day7/test.txt") do
    path
    |> read_input()
    |> dir_sizes()
    |> Enum.filter(fn x -> x <= 100_000 end)
    |> Enum.sum()
  end

  def part2(path \\ "priv/day7/test.txt") do
    sizes =
      path
      |> read_input()
      |> dir_sizes()

    filesystem_size = 70_000_000
    required_space = 30_000_000

    # The root is always largest by definition.
    used_size = Enum.max(sizes)
    available = filesystem_size - used_size
    must_free = required_space - available

    sizes
    |> Enum.sort()
    |> Enum.find(fn s -> s >= must_free end)
  end

  def dir_size(dir) when is_map(dir) do
    file_sizes =
      dir
      |> Map.values()
      |> Enum.filter(&is_integer/1)
      |> Enum.sum()

    dir_sizes =
      dir
      |> Map.values()
      |> Enum.filter(&is_map/1)
      |> Enum.reduce(0, fn d, acc -> dir_size(d) + acc end)

    file_sizes + dir_sizes
  end

  def dir_sizes(root) do
    # This is not optimal at all, it travels through the dirs twice.
    # But it works, so serves as a base line.
    size = dir_size(root)

    subdirs =
      root
      |> Map.values()
      |> Enum.filter(&is_map/1)
      |> Enum.map(&dir_sizes/1)

    List.flatten([size | subdirs])
  end
end
