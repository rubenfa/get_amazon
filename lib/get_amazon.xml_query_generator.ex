defmodule GetAmazon.Xml.QueryGenerator do
  import SweetXml

  #   good = xml |> xmap( 
  #     Items: [
  #       ~x"//Items/Items"l,
  #       asin: ~x"./ASIN/text()"s,
  #       detail_page: ~x"./DetailPage/text()"s
  #     ])

  defmacro amazon_query(do: inner) do
    quote do
      {:ok, var!(buffer, __MODULE__)} = start_buffer([])
      unquote(inner)
      result = get_result(var!(buffer, __MODULE__))
      stop_buffer(var!(buffer, __MODULE__))
      result
    end
  end

  defmacro list(name, xpath, do: inner) do
    quote do
      element_sigil = unquote(xpath)
      element_name = unquote(name)

      element = {String.to_atom(element_name), ~x(#{element_sigil})l}

      put_root(var!(buffer, __MODULE__), element)

      unquote(inner)
    end
  end

  defmacro field(name, xpath, :string) when is_atom(name) do
    quote do
      element = {unquote(name), ~x(#{unquote(xpath)})s}
      put_child(var!(buffer, __MODULE__), element)
    end
  end

  defmacro field(name, xpath, type) do
    quote do
      raise ArgumentError, "Function for element :#{name} and type :#{type} not found"
    end
  end

  def start_buffer(state), do: Agent.start_link(fn -> state end)
  def stop_buffer(buff), do: Agent.stop(buff)

  def put_root(buff, keyword) do
    Agent.update(buff, fn state ->
      put_new(state, keyword)
    end)
  end

  def put_new([], keyword) do
    [[keyword]]
  end

  def put_new(state, keyword) do
    [[keyword] | state]
  end

  def put_child(buff, keyword) do
    Agent.update(buff, fn [root | others] ->
      put_new_child(root, others, keyword)
    end)
  end

  def put_new_child([], root, keyword) do
    updated_root = root ++ [keyword]
    [updated_root]
  end

  def put_new_child(others, root, keyword) do
    updated_root = root ++ [keyword]
    [updated_root, others]
  end

  def get_result(buff) do
    Agent.get(buff, fn state -> state end)
  end

  # defmacro amazon_query(do: inner) do
  #   quote do
  #     {:ok, var!(buffer, __MODULE__)} = start_buffer([])
  #     unquote(inner)
  #     result = get_result(var!(buffer, __MODULE__))
  #     stop_buffer(var!(buffer, __MODULE__))
  #     result
  #   end
  # end

  # def start_buffer(state), do: Agent.start_link(fn -> state end)
  # def stop_buffer(buff), do: Agent.stop(buff)

  # def put_buffer(buff, element) do
  #   Agent.update(buff, fn state -> [element | state] end)
  # end

  # def get_result(buff) do
  #   Agent.get(buff, fn state -> state end)
  # end

  # defmacro list(name, xpath, do: inner) do
  #   quote do
  #     element_sigil = unquote(xpath)
  #     element_name = unquote(name)

  #     element = [{String.to_atom(element_name), ~x(#{element_sigil})l}]

  #     put_buffer(var!(buffer, __MODULE__), element)

  #     unquote(inner)
  #   end
  # end

  # #   good = xml |> xmap( 
  # #     Items: [
  # #       ~x"//Items/Items"l,
  # #       asin: ~x"./ASIN/text()"s,
  # #       detail_page: ~x"./DetailPage/text()"s
  # #     ])

  # defmacro field(name, xpath, :string) when is_atom(name) do
  #   quote do
  #     element = {unquote(name), ~x(#{unquote(xpath)})s}
  #     IO.inspect(__MODULE__)
  #     put_buffer(var!(buffer, __MODULE__), element)
  #   end
  # end

  # defmacro field(name, xpath, type) do
  #   quote do
  #     raise ArgumentError, "Function for element :#{name} and type :#{type} not found"
  #   end
  # end
end
