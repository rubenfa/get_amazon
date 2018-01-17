defmodule GetAmazon.GetInfoMacro do
  use ExUnit.Case
  doctest GetAmazon.GetInfo

  import GetAmazon.GetInfo

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

end
