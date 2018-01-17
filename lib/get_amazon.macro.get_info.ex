defmodule GetAmazon.GetInfo do
  @moduledoc """
  **This macro is working in progress**. I'm trying to provide a DSL to make petitions to Amazon APIO
  """

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
