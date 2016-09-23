defmodule GetAmazonTest do
  use ExUnit.Case
  doctest GetAmazon.Composer

  alias GetAmazon.Composer
  alias GetAmazon.Security
  alias GetAmazon.RequestProcessor

  test "all search has AWSAccessKeyId key" do
    sut = Composer.generate_url [SearchIndex: "Electronic"]
    assert(String.contains? sut, "AWSAccessKeyId=")
  end

  test "all search has AssociateTag key" do
    sut = Composer.generate_url [SearchIndex: "Electronic"]
    assert(String.contains? sut, "AssociateTag=")
  end

  test "empty list of filters return url" do
    sut = Composer.generate_url []
    assert(String.contains?(sut, "http://"))
  end

  test "returned url contains parameters like input filters" do   
    sut = Composer.generate_url [SearchIndex: "Books", Keywords: "Matrix"]
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

    query_string = "AWSAccessKeyId=123456&AssociateTag=PutYourAssociateTagHere&Keywords=harry%20potter&Operation=ItemSearch&SearchIndex=Books&Service=AWSECommerceService&Timestamp=2016-06-22T06%3A27%3A37.000Z&Version=2011-08-01"

    sut =  Security.create_signature(query_string, url_params)
    assert(URI.encode_www_form(sut) == "xFL89SFVOwHwIHoF1YdT%2F1qtrmTgVIDjiO4gNsiMN%2Bw%3D")
  end

  defp read_xml_sample() do
    {_, xml} =  File.read("test/sample.xml")
    xml
  end

  test "xml parse returns a Map" do
    result = read_xml_sample |> RequestProcessor.get_items    
    assert(is_map(result))
  end

  test "xml parse returns a Map with some specific fields" do

    result = read_xml_sample |> RequestProcessor.get_items
    assert(Map.has_key?(result, :MoreResultsURL))

    has_keys? =
      result[:Items] |>
      Enum.all?(fn(x) ->
        Map.has_key?(x, :ASIN) and
        Map.has_key?(x, :Title) and
        Map.has_key?(x, :Brand) and
        Map.has_key?(x, :Color) and
        Map.has_key?(x, :Features) and
        Map.has_key?(x, :TextPrice) and
        Map.has_key?(x, :DetailURL) and
        Map.has_key?(x, :SmallImage) and
        Map.has_key?(x, :MediumImage) and
        Map.has_key?(x, :LargeImage) and
        Map.has_key?(x, :ReviewIFrameURL)
    end)

    assert (has_keys? == true)    
  end





end
