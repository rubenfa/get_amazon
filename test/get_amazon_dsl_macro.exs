defmodule GetAmazon.GetInfoMacro do
  use ExUnit.Case
  doctest GetAmazon.GetInfo

  import GetAmazon.GetInfo

  alias GetAmazon.GetInfo

  """
  amazon_type xml do
    get :asin
    get :description
  end


  """

  test "macro is loaded" do
    assert Code.ensure_loaded?(GetAmazon.GetInfo)
  end

  test "macro using get" do
    result =
      amazon_type :book, "" do
        get(:asin)
        get(:title)
      end

    assert result == %{:asin => 1234, :title => "Book title"}
  end

  test "Macro has not valid element for get" do
    assert_raise ArgumentError, "Element noexist not found", fn ->
      amazon_type :book, "" do
        get(:noexist)
      end
    end
  end

  test "Testing SweetXml creation types" do
    result = 'sl' |> GetInfo.create_sweet_type()
    assert result == 'sl'
  end

  test "Testing SweetXml creation types with duplicates " do
    result = 'sFFl' |> GetInfo.create_sweet_type()
    assert result == 'sFl'
  end

  test "Testing SweetXml sigil creation without types" do
    result = GetInfo.create_sweet_sigil("\\Items", "")

    assert result == %SweetXpath{
             path: '\\Items'
           }
  end

  test "Testing SweetXml sigil creation with type l" do
    result = GetInfo.create_sweet_sigil("\\Items", "l")
    IO.inspect(result)

    assert result == %SweetXpath{
             path: '\\Items',
             is_list: true
           }
  end

  test "Testing SweetXml sigil creation with type ls" do
    result = GetInfo.create_sweet_sigil("\\Items", "ls")
    IO.inspect(result)

    assert result == %SweetXpath{
             path: '\\Items',
             is_list: true,
             cast_to: :string
           }
  end

  test "Testing SweetXml sigil creation with type lS" do
    result = GetInfo.create_sweet_sigil("\\Items", "lS")
    IO.inspect(result)

    assert result == %SweetXpath{
             path: '\\Items',
             is_list: true,
             cast_to: :soft_string
           }
  end

  test "Loading file with SweetXml expressions" do
    result = GetInfo.load_from_file("../test/schemas/test_item_search_request.txt")

    assert result == [
             {"NODE",
              %SweetXpath{
                cast_to: false,
                is_keyword: false,
                is_list: true,
                is_optional: false,
                is_value: true,
                namespaces: [],
                path: '//Items',
                transform_fun: &SweetXpath.Priv.self_val/1
              }, "Items",
              %SweetXpath{
                cast_to: false,
                is_keyword: false,
                is_list: false,
                is_optional: false,
                is_value: true,
                namespaces: [],
                path: './Item',
                transform_fun: &SweetXpath.Priv.self_val/1
              }},
             {"LEAF",
              %SweetXpath{
                cast_to: false,
                is_keyword: false,
                is_list: true,
                is_optional: false,
                is_value: true,
                namespaces: [],
                path: './Item',
                transform_fun: &SweetXpath.Priv.self_val/1
              }, "asin",
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
             {"LEAF",
              %SweetXpath{
                cast_to: false,
                is_keyword: false,
                is_list: true,
                is_optional: false,
                is_value: true,
                namespaces: [],
                path: './Item',
                transform_fun: &SweetXpath.Priv.self_val/1
              }, "detail_page",
              %SweetXpath{
                cast_to: :string,
                is_keyword: false,
                is_list: false,
                is_optional: false,
                is_value: true,
                namespaces: [],
                path: './DetailPage/text()',
                transform_fun: &SweetXpath.Priv.self_val/1
              }}
           ]
  end


  test "Schema readed has to be converted to structure" do
    result = GetInfo.load_xpaths("../test/schemas/test_item_search_request.txt")

    assert result == []
  end

  # ROOT;~x"//Items"
  # Items;~x"./Item"l
  # asin;~x"./ASIN/text()"s
  # detail_page;~x"./DetailPage/text()"s

  test "Macro load xpaths from file" do
    xpaths = GetAmazon.GetInfo.load_xpaths()

    assert xpaths == []
  end
end
