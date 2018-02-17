defmodule IslandsEngine.Coordinate do
  @moduledoc """
  An abstaction for a coordinate. Contains row and columns for example:

        col  col  col
  --------------------
  row | 00 | 01 | 02
  row | 10 | 11 | 12
  row | 20 | 21 | 22

  """
  alias __MODULE__
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_range 1..10

  defguard within_range(row, col)
           when row in @board_range and col in @board_range

  @doc """
  Returns a new coordinate which is within the range.

  Returns {:ok, %Coordinate{row: row, col: col}}

  ## Examples
    iex> IslandsEngine.Coordinate.new(5, 1)
    {:ok, %IslandsEngine.Coordinate{row: 5, col: 1}}

    iex> IslandsEngine.Coordinate.new(-1, 14)
    {:error, :invalid_coordinate}

  """
  def new(row, col) when within_range(row, col) do
    {:ok, %Coordinate{row: row, col: col}}
  end

  def new(_row, _col) do
    {:error, :invalid_coordinate}
  end
end
