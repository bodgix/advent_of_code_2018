defmodule Day3Star2 do
  @moduledoc """
  Solution to the second puzzle from Day 3
  """

  @input_file "input-day3"

  @doc """
  Takes a rectangle tuple parsed from input and returns a tuple
  {label, %MapSet{}} where MapSet contains all the points of the rectangle
  """
  def rect_tuple_to_set_label_tuple({label, x, y, width, height} = _rect) do
    rect_pts_list = for xs <- x..(x + width - 1), ys <- y..(y + height - 1), do: {xs, ys}

    set =
      rect_pts_list
      |> Enum.reduce(MapSet.new(), &MapSet.put(&2, &1))

    {label, set}
  end

  @doc """
  Finds a rectangle which does not overlap with any other rectanlge in the listś
  """
  def find_non_overlapping(list_of_rects) do
    Enum.reduce_while(list_of_rects, 0, fn {label, rect}, cur_index ->
      search_list = list_of_rects |> List.delete_at(cur_index)

      overlapping =
        search_list
        |> Enum.reduce_while(0, fn {_label, r}, _overlapping_count ->
          if MapSet.intersection(rect, r) |> MapSet.size() > 0 do
            {:halt, 1}
          else
            {:cont, 0}
          end
        end)

      if overlapping == 0, do: {:halt, label}, else: {:cont, cur_index + 1}
    end)
  end

  def main() do
    File.stream!(@input_file, [:read])
    |> Stream.map(fn line -> String.replace_trailing(line, "\n", "") end)
    |> Stream.map(&Day3Star1.parse_line/1)
    |> Stream.map(&rect_tuple_to_set_label_tuple/1)
    |> Enum.to_list()
    |> find_non_overlapping()
    |> IO.puts()
  end
end
