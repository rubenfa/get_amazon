defmodule GetAmazon.RequestProcessor do

import SweetXml

  def get_items(xml) do

    xml |> xpath

  xml
  |> xpath(
     ~x"//Items",
     ASIN: ~x"./ASIN/text()",
     ParentASIN: ~x"./ASIN/text()",
     DetailPageUrl: ~x"./DetailPageURL/text()",
     ImageUrl: ~x"./URL/text()"
  )
end

end 
