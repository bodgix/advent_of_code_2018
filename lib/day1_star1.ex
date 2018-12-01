defmodule Day1Star2 do
  @file_name "input"

  def sum_frequencies(io_stream) do
    io_stream
    |> Stream.map(fn freq_str ->
      {num, _rest} = Integer.parse(freq_str)
      num
    end)
    |> Enum.reduce(0, fn freq, acc ->
      acc + freq
    end)
  end

  def main do
    File.stream!(@file_name, [:read])
    |> sum_frequencies()
    |> IO.puts
  end
end
