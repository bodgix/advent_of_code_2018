defmodule Day6Star1 do
  @input_file "input-day6"

  @doc ~S"""
  Parses `enum` into a list of coordinates `{x, y}`

  ## Examples

    iex> {:ok, stream} = "1, 2\n3, 4" |> StringIO.open
    iex> stream |> IO.binstream(:line) |> Day6Star1.parse_input()
    [{1, 2}, {3, 4}]
  """
  def parse_input(enum) do
    enum
    |> Stream.map(fn line -> String.replace_trailing(line, "\n", "") end)
    |> Stream.map(fn line -> line |> String.split(", ") end)
    |> Stream.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
    |> Enum.to_list()
  end

  @doc ~S"""
  Groups coordinates into inner and outer

  ## Examples

    iex> [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}] |> Day6Star1.group_into_inner_and_outer()
    {MapSet.new([{1, 1}, {1, 6}, {8, 3}, {8, 9}]), MapSet.new([{3, 4}, {5, 5}])}

  """

  def group_into_inner_and_outer(enum) do
    sorted_by_x =
      enum
      |> Enum.sort_by(fn {x, _y} -> x end)

    sorted_by_y =
      enum
      |> Enum.sort_by(fn {_x, y} -> y end)

    [min_x_1, min_x_2] = Enum.slice(sorted_by_x, 0..1) |> Enum.map(fn {x, _y} -> x end)
    [max_x_1, max_x_2] = Enum.slice(sorted_by_x, -2..-1) |> Enum.map(fn {x, _y} -> x end)
    [min_y_1, min_y_2] = Enum.slice(sorted_by_y, 0..1) |> Enum.map(fn {_x, y} -> y end)
    [max_y_1, max_y_2] = Enum.slice(sorted_by_y, -2..-1) |> Enum.map(fn {_x, y} -> y end)

    enum
    |> Enum.reduce({MapSet.new(), MapSet.new()}, fn {x, y} = coord, {outer_set, inner_set} ->
      cond do
        x > min_x_1 && x > min_x_2 && x < max_x_1 && x < max_x_2 && y > min_y_1 && y > min_y_2 &&
          y < max_y_1 && y < max_y_2 ->
          {outer_set, MapSet.put(inner_set, coord)}

        true ->
          {MapSet.put(outer_set, coord), inner_set}
      end
    end)
  end

  @doc """
  Creates a rectangle that contains all the `points` inside it's borders.
  Returns the upper-left and bottom-right coordinates

  ## Examples
    iex> [{0, 0}, {0, 1}, {0, 2}, {1, 0}, {1, 1}, {1, 2}, {2, 0}, {2, 1}, {2, 2}]
    ...> |> Day6Star1.generate_frame()
    {{0, 0}, {2, 2}}

  """
  def generate_frame(points) do
    sorted_by_x =
      points
      |> Enum.sort_by(fn {x, _y} -> x end)

    sorted_by_y =
      points
      |> Enum.sort_by(fn {_x, y} -> y end)

    min_x =
      sorted_by_x
      |> List.first()
      |> Tuple.to_list()
      |> List.first()

    max_x =
      sorted_by_x
      |> List.last()
      |> Tuple.to_list()
      |> List.first()

    min_y =
      sorted_by_y
      |> List.first()
      |> Tuple.to_list()
      |> List.last()

    max_y =
      sorted_by_y
      |> List.last()
      |> Tuple.to_list()
      |> List.last()

    {{min_x, min_y}, {max_x, max_y}}
  end

  @doc """
  Checks if a `point` is inside a `frame`

  ## Examples
    iex> {1, 1} |> Day6Star1.inside_frame?({{0, 0}, {2, 2}})
    true

    iex> {0, 0} |> Day6Star1.inside_frame?({{0, 0}, {2, 2}})
    false

    iex> {-1, -1} |> Day6Star1.inside_frame?({{0, 0}, {2, 2}})
    false
  """
  def inside_frame?({x, y} = _point, {{min_x, min_y}, {max_x, max_y}} = _frame) do
    x > min_x && y > min_y && x < max_x && y < max_y
  end

  @doc """
  Returns the [Manhattan distance](https://en.wikipedia.org/wiki/Taxicab_geometry) between two points

  ## Examples

    iex> Day6Star1.manhattan_distance({0, 0}, {6, 6})
    12
  """
  def manhattan_distance({x1, y1} = _point1, {x2, y2} = _point2), do: abs(x1 - x2) + abs(y1 - y2)

  @doc """
  Returns the size of the area around a `point` which consists of points for whom the closer other point
  is the checked point

  ## Examples

    iex> [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}] |> Day6Star1.proximity_area({5, 5})
    17
  """
  def proximity_area(points, {_x, _y} = point, frame) do
    point |> IO.inspect(label: "Proximity area for")

    points = List.delete(points, point)

    first_square = MapSet.new([point])

    {area, _last_square} =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while({0, first_square}, fn radius, {area, prev_square} ->
        cur_square = build_square(point, radius)

        partial_areas =
          cur_square
          |> MapSet.difference(prev_square)
          |> Enum.map(fn cur_point ->
            cond do
              cur_point |> inside_frame?(frame) ->
                dist_from_center = manhattan_distance(cur_point, point)

                manhatan_distances(points, cur_point)
                |> Enum.reduce_while(0, fn dist_from_other, _break ->
                  cond do
                    dist_from_other <= dist_from_center ->
                      {:halt, 0}

                    true ->
                      {:cont, 1}
                  end
                end)

              true ->
                0
            end
          end)

        partial_area = Enum.sum(partial_areas)

        cond do
          partial_area > 0 ->
            {:cont, {area + partial_area, cur_square}}

          true ->
            {:halt, {area, cur_square}}
        end
      end)

    (area + 1)
    |> IO.inspect(label: "Result:")
  end

  def manhatan_distances(points, point) do
    points
    |> Enum.map(fn p -> manhattan_distance(p, point) end)
  end

  @doc """
  Returns all points that belong to the square with a center `point` and `radius`

  ## Examples
    iex> Day6Star1.build_square({1, 1}, 1)
    [{0, 0}, {1, 0}, {2, 0}, {0, 1}, {1, 1}, {2, 1}, {0, 2}, {1, 2}, {2, 2}] |> MapSet.new()

  """
  def build_square({x, y} = _point, radius) do
    for(xs <- (x - radius)..(x + radius), ys <- (y - radius)..(y + radius), do: {xs, ys})
    |> MapSet.new()
  end

  def draw(enum) do
    frame = Frame.init(353, 353, RGBA.white())

    filled_frame =
      enum
      |> Enum.reduce(frame, fn {x, y}, frame ->
        new_frame =
          frame
          |> Frame.push(Point.init(x, y), RGBA.black())

        new_frame
      end)

    filled_frame
    |> PNG.to_png("points.png")
  end

  def main() do
    points =
      File.stream!(@input_file, [:read])
      |> parse_input()

    frame =
      points
      |> generate_frame()

    points
    |> Enum.map(fn point -> proximity_area(points, point, frame) end)
    |> Enum.sort()
    |> List.last()
    |> IO.puts()
  end
end
