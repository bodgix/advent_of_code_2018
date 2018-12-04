defmodule Day3Star1 do
  @moduledoc """
  Solution to the first task from Day3
  """
  @input_file "input-day3"

  @doc """
  Parses strings of the form:
  #1 @ 1,3: 4x4

  Returns a tuple: {label, x, y, width, height}

  ## Example
    "#1 @ 1,3: 4x4" |> parse_line()

    => {1, 1, 3, 4, 4}
  """
  def parse_line(line) do
    ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
    |> Regex.run(line)
    |> Enum.slice(1, 1000)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  @doc """
  Takes a tuple with rectangle definition and builds a map with
  all points/squares of the rectangle as keys and 1 as value

  ## Example
    {1, 0, 0, 1, 1} |> build_rect_map()

    => %{
         {0, 0} => 1,
         {0, 1} => 1,
         {1, 0} => 1,
         {1, 1} => 1
       }
  """
  def build_rect_map({_label, x, y, width, height} = _rect_tuple) do
    rect_pts_list = for xs <- x..(x + width - 1), ys <- y..(y + height - 1), do: {xs, ys}

    rect_pts_list
    |> Enum.reduce(%{}, &Map.put(&2, &1, 1))
  end

  def main() do
    File.stream!(@input_file, [:read])
    |> Stream.map(fn line -> String.replace_trailing(line, "\n", "") end)
    |> Stream.map(&parse_line/1)
    |> Stream.map(&build_rect_map/1)
    |> Enum.reduce(%{}, fn rect_map, result ->
      Map.merge(result, rect_map, fn _k, v1, v2 -> v1 + v2 end)
    end)
    |> Enum.filter(fn {_k, v} -> v > 1 end)
    |> Enum.count()
    |> IO.puts()
  end
end
