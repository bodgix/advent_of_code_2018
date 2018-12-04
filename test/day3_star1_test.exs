defmodule Day3Test do
  use ExUnit.Case

  test "parse_line returns a tuple with data" do
    assert "#1 @ 1,3: 4x4" |> Day3Star1.parse_line() == {1, 1, 3, 4, 4}
  end

  test "build_rect_map returns a map with all points" do
    assert {1, 0, 0, 2, 2} |> Day3Star1.build_rect_map() == %{
             {0, 0} => 1,
             {0, 1} => 1,
             {1, 0} => 1,
             {1, 1} => 1
           }
  end
end
