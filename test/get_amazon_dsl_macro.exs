defmodule GetAmazon.GetInfoMacro do
  use ExUnit.Case
  doctest GetAmazon.GetInfo

  import GetAmazon.GetInfo
  import SweetXml
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

  test "Loading file with SweetXml expressions" do
    result = GetInfo.load_from_file("../test/schemas/test_item_search_request.txt")

    assert result == [
             {"Items", "all00", "~x\"//Items/Items\"l"},
             {"Items", "asin", "~x\"./ASIN/text()\"s"},
             {"Items", "detail_page", "~x\"./DetailPage/text()\"s"}
           ]
  end

  test "Schema readed has to be converted to structure" do
    result = GetInfo.load_xpaths("../test/schemas/test_item_search_request.txt")

    assert result == []
  end

  # ROTO;~x"//Items"
  # Items;~x"./Item"l
  # asin;~x"./ASIN/text()"s
  # detail_page;~x"./DetailPage/text()"s

  # test "Macro load xpaths from file" do
  #   xpaths = GetInfo.load_xpaths("../test/schemas/test_item_search_request.txt")

  #   xml = read_xml_sample()

  #   good = xml |> xmap( 
  #     Items: [
  #       ~x"//Items/Items"l,
  #       asin: ~x"./ASIN/text()"s,
  #       detail_page: ~x"./DetailPage/text()"s
  #     ])

  #   test = xml |> xmap(nil, nil, xpaths)

  #   assert good == test
  #  end

  def read_xml_sample() do
    path = Path.expand("./sample.xml", __DIR__)
    File.read!(path)
  end
end

# xmap(
#   matchups: [
#     ~x"//matchups/matchup"l,
#     name: ~x"./name/text()",
#     winner: [
#       ~x".//team/id[.=ancestor::matchup/@winner-id]/..",
#       name: ~x"./name/text()"
#     ]
#   ],
#   last_matchup: [
#     ~x"//matchups/matchup[last()]",
#     name: ~x"./name/text()",
#     winner: [
#       ~x".//team/id[.=ancestor::matchup/@winner-id]/..",
#       name: ~x"./name/text()"
#     ]
#   ]
# ()
