defmodule Day4Star1 do
  @moduledoc """
  Solution to the first puzzle of the Day4 Advent Of Code
  """

  @input_file "input-day4"

  def parse_input(stream) do
    stream
    |> Stream.map(fn line ->
      [_all, date, rest] =
        ~r/\[([^]]+)\] (.*)/
        |> Regex.run(line)

      {:ok, parsed_date} =
        (date <> ":00")
        |> NaiveDateTime.from_iso8601()

      cond do
        Regex.run(~r/Guard #(\d+) begins shift/, rest) ->
          [_, guard] = Regex.run(~r/Guard #(\d+) begins shift/, rest)
          {parsed_date, :begins_shift, guard}

        rest == "falls asleep" ->
          {parsed_date, :falls_asleep}

        rest == "wakes up" ->
          {parsed_date, :wakes_up}
      end
    end)
  end

  def reduce_to_sleep_map(
        {_date, :begins_shift, guard_no},
        %{} = acc
      ) do
    Map.put(acc, :current_guard, guard_no)
  end

  def reduce_to_sleep_map(
        {date, :falls_asleep},
        %{current_guard: guard} = acc
      )
      when is_binary(guard) do
    acc
    |> Map.put(:current_state, :sleeping)
    |> Map.put(:sleeping_since, date.minute)
  end

  def reduce_to_sleep_map(
        {date, :wakes_up},
        %{
          current_guard: guard,
          current_state: :sleeping,
          sleeping_since: sleeping_since,
          sleep_map: sleep_map
        } = acc
      )
      when is_binary(guard) do
    new_sleep_map_for_guard =
      sleeping_since..(date.minute - 1)
      |> Enum.reduce(Map.get(sleep_map, guard, %{}), fn minute, sleep_map_of_guard ->
        minutes_slept = Map.get(sleep_map_of_guard, minute, 0) + 1
        Map.put(sleep_map_of_guard, minute, minutes_slept)
      end)

    new_sleep_map = Map.put(sleep_map, guard, new_sleep_map_for_guard)

    acc
    |> Map.put(:current_state, nil)
    |> Map.put(:sleeping_since, nil)
    |> Map.put(:sleep_map, new_sleep_map)
  end

  def main() do
    {guard_id, sleep_map} =
      File.stream!(@input_file, [:read])
      |> Stream.map(fn line -> String.replace_trailing(line, "\n", "") end)
      |> parse_input()
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
      |> Enum.sort_by(fn {_guard, sleep_map} ->
        Enum.reduce(sleep_map, 0, fn {_minute, count}, sum -> sum + count end)
      end)
      |> List.last()

    {best_hour, _times_slept} =
      sleep_map
      |> Map.to_list()
      |> Enum.sort_by(fn {_hour, count} -> count end)
      |> List.last()

    result = String.to_integer(guard_id) * best_hour
    IO.puts(result)
  end
end
