defmodule Day2Star2 do
  @input_file "input-day2"

  @doc """
  Takes an array of labels and returns a MapSet with all adjacent labels
  i.e. labels which differ by one character only
  """
  def find_adjacent_in_all_labels([id | rest], result) do
    new_result = find_adjecent_ids(id, rest, result)
    find_adjacent_in_all_labels(rest, new_result)
  end

  def find_adjacent_in_all_labels([], result) do
    result
  end

  @doc """
  Takes a label and a list of labels and returns a set that contains
  all labels from the list which are adjacent to the label
  """
  defp find_adjecent_ids(id, [other_id | other_ids], %MapSet{} = found_so_far) do
    new_set = check_adjacent_and_update_set(id, other_id, found_so_far)

    find_adjecent_ids(id, other_ids, new_set)
  end

  defp find_adjecent_ids(_id, [], %MapSet{} = found_so_far) do
    found_so_far
  end


  @doc """
  Takes two labels and a MapSet and adds both labels to the mapset if they're
  adjacent.

  Returns the MapSet unchaged when the labels are not adjacent
  """
  defp check_adjacent_and_update_set(id1, id2, %MapSet{} = set) do
    cond do
      adjacent_ids?(to_charlist(id1), to_charlist(id2)) ->
        set
        |> MapSet.put(id1)
        |> MapSet.put(id2)

      true ->
        set
    end
  end

  @doc """
  Compare two package ids (charlists) and return true if they differ by one
  character only

  ## Example
    adjecent_ids?('fghij', 'fguij')
    #=> true

    Because 'fghij' and 'fguij' only differ by one letter: the 3rd character h -> u

    adjecent_ids?('abcde', 'axcye')
    #=> false

    Because 'abcde' and 'axcye' differ by two letters: 2nd letter b -> x, 4th letter d -> y

  """
  defp adjacent_ids?(charlist1, charlist2) do
    diff =
      Enum.zip(charlist1, charlist2)
      |> Enum.reduce_while(0, fn {char1, char2}, acc ->
        new_acc = (abs(char1 - char2) > 0 && acc + 1) || acc
        if new_acc > 1, do: {:halt, new_acc}, else: {:cont, new_acc}
      end)

    diff < 2
  end

  def main() do
    File.stream!(@input_file, [:read])
    |> Stream.map(fn line -> String.replace_trailing(line, "\n", "") end)
    |> Stream.map(&to_charlist/1)
    |> Enum.to_list()
    |> find_adjacent_in_all_labels(MapSet.new())
    |> Enum.to_list()
    |> Enum.zip
    |> Enum.filter(fn {char1, char2} -> char1 == char2 end)
    |> Enum.map(fn {char, char} -> char end)
    |> IO.inspect()
  end
end
