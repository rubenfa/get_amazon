defmodule GetAmazonTest do
  use ExUnit.Case
  doctest GetAmazon.Composer

  alias GetAmazon.Composer

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
  
end
