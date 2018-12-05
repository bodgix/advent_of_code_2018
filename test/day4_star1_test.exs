defmodule Day4Test do
  use ExUnit.Case

  test "parse_input parses a line into a NaiveDateTime and the rest of the line" do
    {:ok, stream} =
      """
      [1518-11-01 00:00] Guard #10 begins shift
      [1518-11-01 00:05] falls asleep
      """
      |> StringIO.open()

    {:ok, d1} = NaiveDateTime.from_iso8601("1518-11-01 00:00:00")
    {:ok, d2} = NaiveDateTime.from_iso8601("1518-11-01 00:05:00")

    result =
      stream
      |> IO.binstream(:line)
      |> Stream.map(fn line -> String.replace_trailing(line, "\n", "") end)
      |> Day4Star1.parse_input()
      |> Enum.reduce([], &Enum.concat(&2, [&1]))

    assert result == [{d1, :begins_shift, "10"}, {d2, :falls_asleep}]
  end
end
