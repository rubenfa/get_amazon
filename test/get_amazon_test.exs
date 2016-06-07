defmodule GetAmazonTest do
  use ExUnit.Case
  doctest GetAmazon.Composer

  alias GetAmazon.Composer

  test "all search has AWSAccessKeyId key" do
    sut = Composer.compose_url([])
    assert(String.contains? sut, "AWSAccessKeyId=")
  end

  test "all search has AssociateTag key" do
    sut = Composer.compose_url([])
    assert(String.contains? sut, "AssociateTag=")
  end

  test "empty list of filters return url" do
    sut = Composer.compose_url([])
    assert(String.contains?(sut, "http://"))
  end

  test "returned url contains parameters like input filters" do
    example_list = [{:SearchIndex, "Books"}, {:Keywords, "Matrix Revolutions"}]
    sut = Composer.compose_url(example_list)

    assert(String.contains?(sut, "SearchIndex=Books"))
    assert(String.contains?(sut, "Keywords=Matrix Revolution"))

  end
  
end
