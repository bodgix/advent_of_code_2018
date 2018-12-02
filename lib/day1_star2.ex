defmodule Day1Star2 do
  @file_name "input"

  @doc """
  Sums all numbers from the input stream until a partial sum repeats
  itself.

  Using `Enum.reduce_while` to break out when a repeating partial sum is found.
  """
  def find_repeat(stream) do
    stream
    |> Stream.map(fn freq_str ->
      {num, _rest} = Integer.parse(freq_str)
      num
    end)
    |> Enum.reduce_while(%{sum: 0, freqs: MapSet.new()}, fn freq,
                                                            %{sum: sum, freqs: freqs} = acc ->
      new_sum = sum + freq

      if MapSet.member?(freqs, new_sum) do
        {:halt, %{acc | sum: new_sum}}
      else
        {:cont, %{acc | sum: new_sum, freqs: MapSet.put(freqs, new_sum)}}
      end
    end)
    |> Map.get(:sum)
  end

  @doc """
  Opens the input file as a stream, passes it to `Stream.cycle`
  to create a looped infinite stream.

  Passes the looped stream to find_repeat and prints the reult.
  """
  def main do
    File.stream!(@file_name, [:read])
    |> Stream.cycle()
    |> find_repeat()
    |> IO.puts()
  end
end
