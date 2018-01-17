defmodule GetAmazon.Tests.Security do
  alias GetAmazon.Composer
  alias GetAmazon.Security
  alias GetAmazon.RequestProcessor

  test "all search has AWSAccessKeyId key" do
    sut = Composer.generate_url(SearchIndex: "Electronic")
    assert(String.contains?(sut, "AWSAccessKeyId="))
  end

  test "all search has AssociateTag key" do
    sut = Composer.generate_url(SearchIndex: "Electronic")
    assert(String.contains?(sut, "AssociateTag="))
  end

  test "empty list of filters return url" do
    sut = Composer.generate_url([])
    assert(String.contains?(sut, "http://"))
  end

  test "returned url contains parameters like input filters" do
    sut = Composer.generate_url(SearchIndex: "Books", Keywords: "Matrix")
    assert(String.contains?(sut, "SearchIndex=Books"))
    assert(String.contains?(sut, "Keywords=Matrix"))
  end

  test "the created signature is correct" do
    url_params = [
      APIMethod: "GET",
      APIBaseURL: "ecs.amazonaws.com",
      APIBasePath: "/onca/xml",
      AWSAccessKey: "123456"
    ]

    query_string =
      "AWSAccessKeyId=123456&AssociateTag=PutYourAssociateTagHere&Keywords=harry%20potter&Operation=ItemSearch&SearchIndex=Books&Service=AWSECommerceService&Timestamp=2016-06-22T06%3A27%3A37.000Z&Version=2011-08-01"

    gs
    sut = Security.create_signature(query_string, url_params)
    assert(URI.encode_www_form(sut) == "xFL89SFVOwHwIHoF1YdT%2F1qtrmTgVIDjiO4gNsiMN%2Bw%3D")
  end

  def read_xml_sample() do
    path = Path.expand("./sample.xml", __DIR__)
    File.read!(path)
  end

  test "xml parse returns a Map" do
    result = read_xml_sample() |> RequestProcessor.get_items()
    assert(is_map(result))
    assert Enum.count(result[:Items]) > 0
  end

  test "xml parse returns Total Pages" do
    result = read_xml_sample() |> RequestProcessor.get_items()
    Map.has_key?(result, :TotalPages)
  end

  test "xml parse returns a Item Map with some specific fields" do
    result = read_xml_sample() |> RequestProcessor.get_items()

    has_keys? =
      result[:Items]
      |> Enum.all?(fn x ->
        Map.has_key?(x, :asin)

        Map.has_key?(x, :title) and Map.has_key?(x, :brand) and Map.has_key?(x, :color) and
          Map.has_key?(x, :features) and Map.has_key?(x, :text_price) and
          Map.has_key?(x, :detail_url) and Map.has_key?(x, :image_small) and
          Map.has_key?(x, :image_medium) and Map.has_key?(x, :image_large) and
          Map.has_key?(x, :review_iframe_url) and Map.has_key?(x, :is_prime) and
          Map.has_key?(x, :price) and Map.has_key?(x, :offers)
      end)

    assert has_keys? == true
  end

  test "xml parse returns offers with some specific fields" do
    result = read_xml_sample() |> RequestProcessor.get_items()

    has_keys? =
      result[:Items]
      |> Enum.filter(fn x -> x.offers != [] end)
      |> Enum.flat_map(fn x -> x.offers end)
      |> Enum.all?(fn x ->
        Map.has_key?(x, :merchant) and Map.has_key?(x, :condition) and Map.has_key?(x, :price) and
          Map.has_key?(x, :text_price) and Map.has_key?(x, :availability)
      end)

    assert has_keys? == true
  end
end
