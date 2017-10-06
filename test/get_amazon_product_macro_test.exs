defmodule GetAmazon.Tests.ProductMacro  do

  use ExUnit.Case

  import  GetAmazon.Schema.Types

# alias GetAmazon.Schema.Types

  test "Macro is loaded" do
     assert Code.ensure_loaded?(GetAmazon.Schema.Types)
  end


   test "Product macro is able to use one field" do
     result =
       product do
         field :asin
     end

     assert result == [:asin]
   end

  test "Product macro is able to use more than one field" do
    result =
     product do
      field :asin
      field :name
    end

    assert result == [:asin, :name]
  end


  

end