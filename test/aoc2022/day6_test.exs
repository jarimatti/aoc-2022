defmodule Aoc2022.Day6Test do
  use ExUnit.Case

  alias AoC2022.Day6

  test "part 1: marker is the first repeated character in 4 char sequence" do
    assert(Day6.first_marker_at("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7)
    assert(Day6.first_marker_at("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5)
    assert(Day6.first_marker_at("nppdvjthqldpwncqszvftbrmjlhg") == 6)
    assert(Day6.first_marker_at("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10)
    assert(Day6.first_marker_at("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11)
  end

  test "part 1: message marker is the first repeated character in 14 char sequence" do
    assert(Day6.first_message_at("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19)
    assert(Day6.first_message_at("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23)
    assert(Day6.first_message_at("nppdvjthqldpwncqszvftbrmjlhg") == 23)
    assert(Day6.first_message_at("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29)
    assert(Day6.first_message_at("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26)
  end
end
