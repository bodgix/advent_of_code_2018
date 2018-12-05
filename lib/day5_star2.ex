defmodule Day5Star2 do
  @moduledoc """
  Solution to the second puzzle of Day 5
  """

  @input_file 'input-day5'

  def react_polymer(enumerable) do
    enumerable
    |> Enum.reduce([], fn unit, acc ->
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

  def remove_unit_from_polymer(polymer, removed_unit) do
    polymer
    |> Enum.reduce([], fn [unit], result ->
      cond do
        removed_unit == unit ->
          result

        abs(removed_unit - unit) == 32 ->
          result

        true ->
          result ++ [unit]
      end
    end)
  end

  def all_sub_polymers(enumerable) do
    full_polymer = enumerable |> Enum.to_list()

    enumerable
    |> Stream.map(&to_string/1)
    |> Stream.map(&String.upcase/1)
    |> Enum.reduce({MapSet.new(), []}, fn unit, {checked_units, reacted_polymers} ->
      if MapSet.member?(checked_units, unit) do
        {checked_units, reacted_polymers}
      else
        [char] = unit |> to_charlist()

        polymer_without_unit =
          full_polymer
          |> remove_unit_from_polymer(char)

        {MapSet.put(checked_units, unit),
         reacted_polymers ++ [polymer_without_unit |> react_polymer()]}
      end
    end)
  end

  def main() do
    File.stream!(@input_file, [:read], 1)
    |> Stream.map(&to_charlist/1)
    |> all_sub_polymers()
    |> Tuple.to_list()
    |> List.last()
    |> Enum.sort_by(&Enum.count/1)
    |> List.first()
    |> Enum.count()
    |> IO.puts()
  end
end
