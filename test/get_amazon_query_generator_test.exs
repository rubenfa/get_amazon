defmodule GetAmazon.Xml.QueryGeneratorTests do
  use ExUnit.Case
  doctest GetAmazon.Xml.QueryGenerator

  import GetAmazon.Xml.QueryGenerator
  import CompileTimeAssertions

  test "Ensure macro is loaded" do
    assert Code.ensure_loaded?(GetAmazon.Xml.QueryGenerator)
  end

  test "Field and element are processed" do
    query =
      amazon_query do
        list "Items", "//Items/Items" do
          field(:asin, "./ASIN/text()", :string)
          field(:detail_page, "./DetailPage/text()", :string)
        end
      end

    assert query == [
             [
               [
                 Items: %SweetXpath{
                   cast_to: false,
                   is_keyword: false,
                   is_list: true,
                   is_optional: false,
                   is_value: true,
                   namespaces: [],
                   path: '//Items/Items',
                   transform_fun: &SweetXpath.Priv.self_val/1
                 }
               ],
               {:detail_page,
                %SweetXpath{
                  cast_to: :string,
                  is_keyword: false,
                  is_list: false,
                  is_optional: false,
                  is_value: true,
                  namespaces: [],
                  transform_fun: &SweetXpath.Priv.self_val/1,
                  path: './DetailPage/text()'
                }}
             ],
             [
               asin: %SweetXpath{
                 cast_to: :string,
                 is_keyword: false,
                 is_list: false,
                 is_optional: false,
                 is_value: true,
                 namespaces: [],
                 path: './ASIN/text()',
                 transform_fun: &SweetXpath.Priv.self_val/1
               }
             ]
           ]
  end
end

#   good = xml |> xmap( 
#     Items: [
#       ~x"//Items/Items"l,
#       asin: ~x"./ASIN/text()"s,
#       detail_page: ~x"./DetailPage/text()"s
#     ])
inhibit(same(window))
