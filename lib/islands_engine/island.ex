defmodule IslandsEngine.Island do
  alias __MODULE__
  alias IslandsEngine.{Coordinate}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  def new(type, %Coordinate{} = upper_left) do
    with [_ | _] = offsets <- offsets(type),
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error -> error
    end
  end

  def types(), do: [:atoll, :dot, :l_shape, :s_shape, :square]

  def forested?(island) do
    MapSet.equal?(island.coordinates, island.hit_coordinates)
  end

  def overlaps?(existing_island, new_island) do
    not MapSet.disjoint?(existing_island.coordinates, new_island.coordinates)
  end

  def guess(island, coordinates) do
    case MapSet.member?(island.coordinates, coordinates) do
      true ->
        hit_coordinates = MapSet.put(island.hit_coordinates, coordinates)
        {:hit, %{island | hit_coordinates: hit_coordinates}}

      false ->
        :miss
    end
  end

  @doc """
  Adds coordinates of the offset defined shape where `upper_left` is the starting point.

  ##Example
    iex> square = [{0,0}, {0,1}, {1,0}, {1,1}]
    iex> island = IslandsEngine.Island.add_coordinates(square, %IslandsEngine.Coordinate{row: 2,col: 3})
    iex> assert MapSet.new([
    ...>  %IslandsEngine.Coordinate{col: 3, row: 2},
    ...>  %IslandsEngine.Coordinate{col: 4, row: 2},
    ...>  %IslandsEngine.Coordinate{col: 3, row: 3},
    ...>  %IslandsEngine.Coordinate{col: 4, row: 3},
    ...> ]) == island
    true
  """
  def add_coordinates(offsets, upper_left) do
    offsets
    |> Enum.reduce_while(MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  @doc """
  Adds a coordinate to a list of coordinates.

  ##Example
    iex> coordinates = MapSet.new()
    iex> coordinate = %IslandsEngine.Coordinate{row: 2, col: 1}
    iex> {:cont, ms} = IslandsEngine.Island.add_coordinate(coordinates, coordinate, {3, 4})
    iex> assert inspect(ms) == "#MapSet<[%IslandsEngine.Coordinate{col: 5, row: 5}]>"
    true
    iex> {:halt, {:error, message}} = IslandsEngine.Island.add_coordinate(coordinates, coordinate, {-3, 14})
    iex> assert message == :invalid_coordinate
    true
  """
  def add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} -> {:cont, MapSet.put(coordinates, coordinate)}
      {:error, message} -> {:halt, {:error, message}}
    end
  end

  @doc """
  Offset coordinates for different shapes. The allowed shapes are:
    :dot, :square, :atoll, :l_shape, :s_shape
  """
  def offsets(:dot) do
    [{0, 0}]
  end

  def offsets(:square) do
    [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  end

  def offsets(:atoll) do
    [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  end

  def offsets(:l_shape) do
    [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  end

  def offsets(:s_shape) do
    [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  end

  def offsets(_) do
    {:error, :invalid_island_type}
  end
end
