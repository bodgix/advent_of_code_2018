defmodule Day5Star1 do
  @moduledoc """
  Solution to the first puzzle of Day 5
  """

  @input_file 'input-day5'

  def react_polymer(enumerable) do
    enumerable
    |> Enum.reduce([], fn [unit], acc ->
      case acc do
        [] ->
          [unit]

        [prev_unit | units] ->
          # 32 is the difference between a and A, b and B, etc.
          if abs(prev_unit - unit) == 32 do
            units
          else
            [unit] ++ acc
          end
      end
    end)
  end

  def main() do
    File.stream!(@input_file, [:read], 1)
    |> Stream.map(&to_charlist/1)
    |> react_polymer()
    |> Enum.count()
    |> IO.puts()
  end
end
