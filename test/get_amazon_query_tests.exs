defmodule GetAmazon.RequestProcessorTests do
  use ExUnit.Case
  doctest GetAmazon.RequestProcessor

  import SweetXml
  import GetAmazon.Xml.QueryGenerator
  alias GetAmazon.RequestProcessor

  test "A macro query is composed in the same way as a keyword list" do
    query =
      amazon_query do
        list :Items, "//Items/Item" do
          field(:asin, "./ASIN/text()", :string)
          field(:detail_page, "./DetailPageURL/text()", :string)
        end
      end

    q = [
      Items: [
        ~x"//Items/Item"l,
        asin: ~x"./ASIN/text()"s,
        detail_page: ~x"./DetailPageURL/text()"s
      ]
    ]

    assert q == query
  end

  test "A macro query with optional fields is composed in the same way as a keyword list" do
    query =
      amazon_query do
      list :Items, "//Items/Item" do
        field(:asin, "./ASIN/text()", :string)
        field(:detail_page, "./doesnotexists/text()", :string, [optional: true])
      end
    end

    q = [
      Items: [
        ~x"//Items/Item"l,
        asin: ~x"./ASIN/text()"s,
        detail_page: ~x"./doesnotexists/text()"so
      ]
    ]

    assert q == query
  end

  test "A macro query with not existing fields (but not optional) is composed in the same way as a keyword list" do
    query =
      amazon_query do
      list :Items, "//Items/Item" do
        field(:asin, "./ASIN/text()", :string)
        field(:detail_page, "./doesnotexists/text()", :string)
      end
    end

    q = [
      Items: [
        ~x"//Items/Item"l,
        asin: ~x"./ASIN/text()"s,
        detail_page: ~x"./doesnotexists/text()"s
      ]
    ]

    assert q == query
  end


  test "A macro query returns the correct data from a XML file" do
    query =
      amazon_query do
        list :Items, "//Items/Item" do
          field(:asin, "./ASIN/text()", :string)
          field(:detail_page, "./DetailPageURL/text()", :string)
        end
      end

    result = read_xml_sample |> xmap(query)

    assert result ==
             %{
               Items: [
                 %{
                   asin: "B01CCLPRES",
                   detail_page:
                     "https://www.amazon.es/A10-30F-Smart-c%C3%A1scara-Tableta-TLenovo-Leather/dp/B01CCLPRES%3Fpsc%3D1%26SubscriptionId%3DAKIAIAHAWZ6WT5YRRCRQ%26tag%3Dofertaspatane-21%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB01CCLPRES"
                 },
                 %{
                   asin: "B01G7F75ZY",
                   detail_page:
                     "https://www.amazon.es/Lenovo-Tab-A10-30-Tablet-Android/dp/B01G7F75ZY%3Fpsc%3D1%26SubscriptionId%3DAKIAIAHAWZ6WT5YRRCRQ%26tag%3Dofertaspatane-21%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB01G7F75ZY"
                 },
                 %{
                   asin: "B01EJ581KC",
                   detail_page:
                     "https://www.amazon.es/Lenovo-Vibe-Smartphone-Octa-Core-Importado/dp/B01EJ581KC%3Fpsc%3D1%26SubscriptionId%3DAKIAIAHAWZ6WT5YRRCRQ%26tag%3Dofertaspatane-21%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB01EJ581KC"
                 },
                 %{
                   asin: "B016BC3JQW",
                   detail_page:
                     "https://www.amazon.es/Lenovo-Z51-70-Port%C3%A1til-i5-5200U-gr%C3%A1fica/dp/B016BC3JQW%3Fpsc%3D1%26SubscriptionId%3DAKIAIAHAWZ6WT5YRRCRQ%26tag%3Dofertaspatane-21%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB016BC3JQW"
                 },
                 %{
                   asin: "B01LZC0NPB",
                   detail_page:
                     "https://www.amazon.es/Lenovo-Ideapad-100-15IBD-Port%C3%A1til-i5-5200U/dp/B01LZC0NPB%3Fpsc%3D1%26SubscriptionId%3DAKIAIAHAWZ6WT5YRRCRQ%26tag%3Dofertaspatane-21%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB01LZC0NPB"
                 },
                 %{
                   asin: "B01FLZC8ZI",
                   detail_page:
                     "https://www.amazon.es/Lenovo-Moto-G4-Smartphone-Snapdragon/dp/B01FLZC8ZI%3Fpsc%3D1%26SubscriptionId%3DAKIAIAHAWZ6WT5YRRCRQ%26tag%3Dofertaspatane-21%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB01FLZC8ZI"
                 },
                 %{
                   asin: "B01ND0XJPV",
                   detail_page:
                     "https://www.amazon.es/Lenovo-Ideapad-700-15ISK-I5-6300HQ-operativo/dp/B01ND0XJPV%3Fpsc%3D1%26SubscriptionId%3DAKIAIAHAWZ6WT5YRRCRQ%26tag%3Dofertaspatane-21%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB01ND0XJPV"
                 },
                 %{
                   asin: "B01K2U5EF8",
                   detail_page:
                     "https://www.amazon.es/Lenovo-Ideapad-100-15IBD-Port%C3%A1til-i3-5005U/dp/B01K2U5EF8%3Fpsc%3D1%26SubscriptionId%3DAKIAIAHAWZ6WT5YRRCRQ%26tag%3Dofertaspatane-21%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB01K2U5EF8"
                 },
                 %{
                   asin: "B01CSBJFM2",
                   detail_page:
                     "https://www.amazon.es/Templado-Shatterproof-Pantalla-Tempered-Protector/dp/B01CSBJFM2%3FSubscriptionId%3DAKIAIAHAWZ6WT5YRRCRQ%26tag%3Dofertaspatane-21%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB01CSBJFM2"
                 },
                 %{
                   asin: "B01MQW9YGF",
                   detail_page:
                     "https://www.amazon.es/Protector-Pantalla-Cristal-Templado-Electr%C3%B3nica/dp/B01MQW9YGF%3FSubscriptionId%3DAKIAIAHAWZ6WT5YRRCRQ%26tag%3Dofertaspatane-21%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB01MQW9YGF"
                 }
               ]
             }
  end

  test "A macro query returns the correct data from a XML file when an element does not exists an is declared as optional" do
    query =
      amazon_query do
        list :Items, "//Items/Item" do
          field(:asin, "./ASIN/text()", :string)
          field(:detail_page, "./doesnotexists/text()", :string, [optional: true])
        end
      end

    result = read_xml_sample |> xmap(query)

    assert result ==
      %{Items: [%{asin: "B01CCLPRES", detail_page: ""}, %{asin: "B01G7F75ZY", detail_page: ""}, %{asin: "B01EJ581KC", detail_page: ""}, %{asin: "B016BC3JQW", detail_page: ""}, %{asin: "B01LZC0NPB", detail_page: ""}, %{asin: "B01FLZC8ZI", detail_page: ""}, %{asin: "B01ND0XJPV", detail_page: ""}, %{asin: "B01K2U5EF8", detail_page: ""}, %{asin: "B01CSBJFM2", detail_page: ""}, %{asin: "B01MQW9YGF", detail_page: ""}]}
  end

  test "A macro query returns the correct data from a XML file when an element does not exists an is not  declared as optional" do
    query =
      amazon_query do
      list :Items, "//Items/Item" do
        field(:asin, "./ASIN/text()", :string)
        field(:detail_page, "./doesnotexists/text()", :string)
      end
    end

    result = read_xml_sample |> xmap(query)

    assert result ==
      %{Items: [%{asin: "B01CCLPRES", detail_page: ""}, %{asin: "B01G7F75ZY", detail_page: ""}, %{asin: "B01EJ581KC", detail_page: ""}, %{asin: "B016BC3JQW", detail_page: ""}, %{asin: "B01LZC0NPB", detail_page: ""}, %{asin: "B01FLZC8ZI", detail_page: ""}, %{asin: "B01ND0XJPV", detail_page: ""}, %{asin: "B01K2U5EF8", detail_page: ""}, %{asin: "B01CSBJFM2", detail_page: ""}, %{asin: "B01MQW9YGF", detail_page: ""}]}
  end


  def read_xml_sample() do
    path = Path.expand("./sample.xml", __DIR__)
    File.read!(path)
  end
end
