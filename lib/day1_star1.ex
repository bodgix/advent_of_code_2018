defmodule Day1Star1 do
  @moduledoc """
  Solution to the first part of Day 1 puzzle.
  """
  @file_name "input"

  @doc """
  Sum the "frequencies"

  The input data is called frequencies in the task description.
  They're just positive or nefative integers.

  The function takes a stream, converts strings to integers
  using `Stream.map`. Stream is used so that not to evaluate the stream
  but continue evaluating it lazily.

  Returns:
    The sum of all numbers from the input file.
  """
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

  @doc """
  Opens the input file as a lazyly evaluated stream
  and passes it to `sum_frequencies`

  Prints the result.
  """
  def main do
    File.stream!(@file_name, [:read])
    |> sum_frequencies()
    |> IO.puts()
  end
end
