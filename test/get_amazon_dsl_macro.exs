defmodule GetAmazon.GetInfoMacro do
  use ExUnit.Case
  doctest GetAmazon.GetInfo

  import GetAmazon.GetInfo

  """
  amazon_get(xml) do
     type :book do
      make fn(x) -> %{asin=> x[:asin]}
     end
  end
  """

  test "macro is loaded" do
    assert Code.ensure_loaded?(GetAmazon.GetInfo)
  end
end
