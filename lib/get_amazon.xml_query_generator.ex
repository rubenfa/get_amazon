defmodule GetAmazon.Xml.QueryGenerator do
  import SweetXml

  @moduledoc """

  This module provides a DSL (Domain Specified Language) to generate SweetXML queries, and parse Amazon XML responses into maps.

  There are two types of elements: lists and fields. It's mandatory that fields be withing lists. A list has to have a name (an atom) and an XPath as arguments. A field has to have a name, an XPath and a type as an arguments (:string is alowed).

  Amplié:

    iex> amazon_query do
           list :Items, "//Items/Item" do
           field(:asin, "./ASIN/text()", :string)
           field(:detail_page, "./DetailPageURL/text()", :string)
           end
             end

           [ 
             Items: [
               %SweetXpath{
                 cast_to: false,
                 is_keyword: false,
                 is_list: true,
                 is_optional: false,
                 is_value: true,
                 namespaces: [],
                 path: '//Items/Item',
                 transform_fun: &SweetXpath.Priv.self_val/1
                 },
                 {
                 :asin,
                 %SweetXpath{
                   cast_to: :string,
                   is_keyword: false,
                   is_list: false,
                   is_optional: false,
                   is_value: true,
                   namespaces: [],
                   path: './ASIN/text()',
                   transform_fun: &SweetXpath.Priv.self_val/1
                   }},
                 {
                 :detail_page,
                 %SweetXpath{
                   cast_to: :string,
                   is_keyword: false,
                   is_list: false,
                   is_optional: false,
                   is_value: true,
                   namespaces: [],
                   path: './DetailPageURL/text()',
                   transform_fun: &SweetXpath.Priv.self_val/1
                   }}
             ]
           ]


  """

  @doc  """
  First entry point of the macro is `amazon_query`. This macro starts a AgentServer to use it as buffer to store elements of macro like lists and fields.
  When the macro has processed all children, stops the buffer and return the composed result
  """
  defmacro amazon_query(do: inner) do
    quote do
      {:ok, var!(buffer, __MODULE__)} = start_buffer([])
      unquote(inner)
      result = get_result(var!(buffer, __MODULE__))
      stop_buffer(var!(buffer, __MODULE__))
      result
    end
  end

  @doc """
  Second macro of the sequence. A `list` has to be within `amazon_query` macro. It creates a SweetXml sigil of type list. 

  """
  defmacro list(name, xpath, do: inner) do
    quote do
      element_sigil = unquote(xpath)
      element_name = unquote(name)

      element = {element_name, [~x(#{element_sigil})l]}

      put_root(var!(buffer, __MODULE__), element)

      unquote(inner)
    end
  end

  @doc """
  Field elements has to be within list elements. An element has a type as third parameter. It could be `:string`, `:integer` or `:float`. If a fourth parameter is include

  """

  defmacro field(name, xpath, :string, [optional: true]) do
    quote do
      element = {unquote(name), ~x(#{unquote(xpath)})so}
      put_child(var!(buffer, __MODULE__), element)
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
    Keyword.new([keyword])
  end

  def put_new(state, keyword) do
    [Keyword.new([keyword]) | state]
  end

  def put_child(buff, keyword) do
    Agent.update(buff, fn [root | others] ->
      put_new_child(others, root, keyword)
    end)
  end

  def put_new_child([], root = {key, elements}, keyword) do
    updated_root = {key, elements ++ [keyword]}
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
