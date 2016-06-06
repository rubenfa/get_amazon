defmodule GetAmazonTest do
  use ExUnit.Case
  doctest GetAmazon

  test "all search has AWSAccessKeyId key" do
    sut = GetAmazon.search([])
    assert(String.contains? sut, "AWSAccessKeyId=")
  end

  test "all search has AssociateTag key" do
    sut = GetAmazon.search([])
    assert(String.contains? sut, "AssociateTag=")
  end

  test "empty list of filters return url" do
    sut = GetAmazon.search([])
    assert(String.contains?(sut, "http://"))
  end

  test "returned url contains parameters like input filters" do
    example_list = [{:SearchIndex, "Books"}, {:Keywords, "Matrix Revolutions"}]
    sut = GetAmazon.search(example_list)

    assert(String.contains?(sut, "SearchIndex=Books"))
    assert(String.contains?(sut, "Keywords=Matrix Revolution"))

  end
  
end
