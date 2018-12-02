defmodule Day2Star1 do
  @input_file "input-day2"

  def calculate_checksum(box_ids) do
    box_ids
    |> Stream.map(&to_charlist/1)
    |> Stream.map(&count_elements/1)
    |> Stream.map(&double_tripple/1)
    |> Enum.reduce({0, 0}, fn {double, tripple}, {double_so_far, tripple_so_far} ->
      {double_so_far + double, tripple_so_far + tripple}
    end)
    |> (fn {double, tripple} -> double * tripple end).()
  end

  def count_elements(list) do
    list
    |> Enum.reduce(%{}, fn elem, acc ->
      Map.update(acc, elem, 1, &(&1 + 1))
    end)
  end

  def double_tripple(map_with_counts) do
    map_with_counts
    |> Enum.reduce({0, 0}, fn {_char, count}, {cnt_2, cnt_3} = result ->
      case count do
        2 ->
          {1, cnt_3}

        3 ->
          {cnt_2, 1}

        _ ->
          result
      end
    end)
  end

  def main() do
    File.stream!(@input_file, [:read])
    |> calculate_checksum()
    |> IO.puts()
  end
end
