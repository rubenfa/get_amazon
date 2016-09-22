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

  test "xml parse returns a Map" do
    xml = File.read("test/sample.xml")
    result = RequestProcessor.get_items(xml)
    assert(is_map(result))
  end

  test "xml parse returns a Map with some specific fields" do
    xml = File.read("test/sample.xml")

    result = RequestProcessor.get_items(xml)

    assert Map.has_key?(result, "ASIN")
    assert Map.has_key?(result, "Title")
    assert Map.has_key?(result, "Brand")
    assert Map.has_key?(result, "Color")
    assert Map.has_key?(result, "Features")
    assert Map.has_key?(result, "TextPrice")
    assert Map.has_key?(result, "DetailURL")
    assert Map.has_key?(result, "SmallImage")
    assert Map.has_key?(result, "MediumImage")
    assert Map.has_key?(result, "LargeImage")
    assert Map.has_key?(result, "ReviewIFrameURL")
  end





end
