defmodule Issues.TableFormatter do
  def print_table_for_columns(list_of_hashdicts, list_of_column_title_maps) do
    list_of_column_title_maps
    |> Enum.map(&add_width(&1, list_of_hashdicts))
    |> output_title
    |> output_table(list_of_hashdicts)
  end

  def output_table(list_of_column_map, list_of_hashdicts) do
    list_of_hashdicts
    |> Enum.map(&output_line(&1, list_of_column_map))
  end
  
  def output_line(hashdict, list_of_column_map) do
    for %{column: key, width: width} <- list_of_column_map do
      hashdict
      |> HashDict.fetch!(key)
      |> to_string
      |> String.ljust(width)
    end
    |> Enum.join(" | ")
    |> IO.puts
  end

  def output_title(list_of_column_map) do
    list_of_column_map
    |> Enum.map(fn %{title: title, width: width} -> String.ljust(title, width) end)
    |> Enum.join(" | ")
    |> IO.puts

    list_of_column_map
    |> Enum.map(fn %{width: width} -> String.duplicate("-", width) end)
    |> Enum.join("-+-")
    |> IO.puts

    list_of_column_map
  end

  def add_width(column_map, list_of_hashdicts) do
    %{column: key} = column_map
    width =
    list_of_hashdicts
    |> Enum.map(fn hd -> HashDict.fetch!(hd, key) |> to_string |> String.length end )
    |> Enum.max
    
    Dict.put(column_map, :width, width)
  end
end
