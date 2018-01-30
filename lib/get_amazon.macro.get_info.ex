defmodule GetAmazon.GetInfo do
  import SweetXml

  @file_xpaths "/schemas/item_search_request.txt"

  @moduledoc """
  **This macro is working in progress**. I'm trying to provide a DSL to make petitions to Amazon API
  """

  defmacro __using__() do
    quote do
      GetAmazon.GetInfo.load_xpaths()
    end
  end

  def load_xpaths(file_name) do

    xpaths =load_from_file(file_name)

    IO.inspect(xpaths)

    xpaths
    |> Enum.reverse
    |> Enum.reduce([], fn(x, acc) -> create_sigil_call(x, acc) end)    
  end


  def create_sigil_call({"NODE", parent, name, xpath}, acc) do
    element =[parent, [ { String.to_atom(name), xpath}]]
    [element | acc]
  end

  def create_sigil_call({"LEAF", parent, name, xpath}, acc) do
    

    ["a" | acc]
  end

  def load_from_file(file_name) do
    File.stream!(Path.join([__DIR__, file_name]))
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> Enum.map(fn line -> line |> String.split(";") |> List.to_tuple() end)
    |> Enum.map(fn {node_type, parent, parent_type, name, xpath, xpath_type} ->
      {node_type, create_sweet_sigil(parent, parent_type), name,
       create_sweet_sigil(xpath, xpath_type)}
    end)
  end

  def create_sweet_sigil(parent, "") do
    SweetXml.sigil_x(parent)
  end

  def create_sweet_sigil(parent, type) do
    sweet_type = type |> to_charlist |> create_sweet_type
    SweetXml.sigil_x(parent, sweet_type)
  end

  def create_sweet_type(type) do
    type
    |> Enum.uniq()
  end

  defmacro amazon_type(type, xml, do: get_block) do
    quote do
      {:ok, var!(buffer, __MODULE__)} = start_buffer(xml: unquote(xml), result_map: %{})
      unquote(get_block)
      result = get_result(var!(buffer, __MODULE__))
      stop_buffer(var!(buffer, __MODULE__))
      result
    end
  end

  defmacro get(:asin) do
    quote do
      put_buffer(var!(buffer, __MODULE__), {:asin, 1234})
    end
  end

  defmacro get(:title) do
    quote do
      put_buffer(var!(buffer, __MODULE__), {:title, "Book title"})
    end
  end

  defmacro get(x) do
    quote do
      raise ArgumentError, "Element #{to_string(unquote(x))} not found"
    end
  end

  def start_buffer(state), do: Agent.start_link(fn -> state end)
  def stop_buffer(buff), do: Agent.stop(buff)

  def put_buffer(buff, {key, value}) do
    Agent.update(buff, fn state ->
      new_map = state[:result_map] |> add_key(key, value)

      Keyword.put(state, :result_map, new_map)
    end)
  end

  def get_result(buff) do
    Agent.get(buff, fn state -> state[:result_map] end)
  end

  def get_xml(buff), do: Agent.get(buff, fn state -> state[:xml] end)

  def add_key(map_state, key, value) do
    Map.put(map_state, key, value)
  end
end
