defmodule Day4Star2 do
  @input_file "input-day4"

  def main() do
    {guard_id, most_frequent_hour, _count} =
      File.stream!(@input_file, [:read])
      |> Stream.map(fn line -> String.replace_trailing(line, "\n", "") end)
      |> Day4Star1.parse_input()
      |> Enum.sort_by(
        fn tuple -> Tuple.to_list(tuple) |> List.first() end,
        &(NaiveDateTime.compare(&1, &2) != :gt)
      )
      |> Enum.reduce(
        %{current_guard: nil, current_state: nil, sleeping_since: nil, sleep_map: %{}},
        &Day4Star1.reduce_to_sleep_map/2
      )
      |> Map.get(:sleep_map)
      |> Map.to_list()
      |> Enum.map(fn {guard_id, guard_sleep_map} ->
        guard_sleep_map
        |> Map.to_list()
        |> Enum.map(fn {minute, count} ->
          {guard_id, minute, count}
        end)
      end)
      |> List.flatten()
      |> IO.inspect(label: "List of hours")
      |> Enum.sort_by(fn {_guard_id, _minute, count} -> count end)
      |> IO.inspect(label: "Sorted list of hours")
      |> List.last()

    (String.to_integer(guard_id) * most_frequent_hour)
    |> IO.puts()
  end
end
