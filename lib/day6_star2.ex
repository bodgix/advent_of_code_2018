defmodule Day6Star2 do
  @input_file "input-day6"
  @safe_distance 10000

  import Day6Star1

  def points_in_safe_distance(points_to_check, all_points, safe_distance) do
    sum =
      points_to_check
      |> Enum.map(fn point ->
        dists_sum =
          all_points
          |> List.delete(point)
          |> manhatan_distances(point)
          |> Enum.sum()

        if dists_sum < safe_distance, do: 1, else: 0
      end)
      |> Enum.sum()

    sum
  end

  def safe_area_around_point(points, {_x, _y} = point, safe_distance) do
    {area, _square} =
      Stream.iterate(0, &(&1 + 1))
      |> Enum.reduce_while({0, MapSet.new()}, fn radius, {area, last_square} ->
        new_square = build_square(point, radius)

        partial_area =
          new_square
          |> MapSet.difference(last_square)
          |> points_in_safe_distance(points, safe_distance)

        if partial_area > 0,
          do: {:cont, {area + partial_area, new_square}},
          else: {:halt, {area, new_square}}
      end)

    area
  end

  def square_touches_frame?(square, frame) do
    square
    |> Enum.reduce_while(false, fn point ->
      if inside_frame?(point, frame), do: {:cont, false}, else: {:halt, true}
    end)
  end

  def main() do
    points =
      File.stream!(@input_file, [:read])
      |> parse_input()

    points
    |> Enum.map(fn point ->
      safe_area_around_point(points, point, @safe_distance)
    end)
  end
end
