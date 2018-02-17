defmodule IslandsEngine.Guesses do
  @moduledoc """
  Modules for guessing results for the game.
  """
  alias IslandsEngine.{Guesses, Coordinate}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @doc """
  Initializes the database of guesses.

  ## Example
    iex> IslandsEngine.Guesses.new()
    %IslandsEngine.Guesses{hits: %MapSet{}, misses: %MapSet{}}
  """
  def new() do
    %Guesses{hits: MapSet.new(), misses: MapSet.new()}
  end

  @doc """
  Inserts a new guess to the database.

  ##Example
    iex> guesses = IslandsEngine.Guesses.new()
    iex> new_coord = %IslandsEngine.Coordinate{row: 1, col: 1}
    iex> guesses = IslandsEngine.Guesses.add(guesses, :hit, new_coord)  
    iex> assert inspect(guesses.hits) == "#MapSet<[%IslandsEngine.Coordinate{col: 1, row: 1}]>"
    true
    iex> guesses = IslandsEngine.Guesses.add(guesses, :miss, new_coord)  
    iex> assert inspect(guesses.misses) == "#MapSet<[%IslandsEngine.Coordinate{col: 1, row: 1}]>"
    true
  """
  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  end

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate) do
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
  end
end
