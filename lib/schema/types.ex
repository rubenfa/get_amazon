defmodule GetAmazon.Schema.Types do

  defmacro product(do: block)  do

    quote do
      {:ok, var!(buffer, GetAmazon.Schema.Types) } = start_buffer([])
      unquote(block)
      result = get_buffer(var!(buffer, GetAmazon.Schema.Types))
      stop_buffer(var!(buffer, GetAmazon.Schema.Types))


      case result == Enum.uniq(result) do
        true -> result
        false -> raise ArgumentError, message: "Product can not have duplicated elements"
      end
     
    end
  end

  
  defmacro field(name) do
    quote do
      put_buffer(var!(buffer, GetAmazon.Schema.Types), unquote(name))
    end
  end

  def start_buffer(state), do: Agent.start_link(fn -> state end)
  def stop_buffer(buff), do: Agent.stop(buff)
  def put_buffer(buff, content), do: Agent.update(buff, &[content | &1])
  def get_buffer(buff), do: Agent.get(buff, &(&1)) |> Enum.reverse

 end
