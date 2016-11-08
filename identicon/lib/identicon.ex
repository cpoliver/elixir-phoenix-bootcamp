defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_colour
    |> build_grid
    |> filter_odd_squares
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def pick_colour(%Identicon.Image{hex: [r, g, b | _]} = image) do
    %Identicon.Image{image | colour: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

     %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
     row ++ (row |> Enum.take(2) |> Enum.reverse)
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    filtered_grid = Enum.filter grid, fn({code, _}) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: filtered_grid}
  end
end
