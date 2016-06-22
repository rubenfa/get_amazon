defmodule GetAmazon.Searcher do

  import SweetXml
  alias GetAmazon.Composer
  
  
  def search(filters) do
    HTTPoison.start

    Composer.generate_url(filters)
    |> HTTPoison.get!
    |> parse_response_body
    |> xpath(~x"//ItemSearchResponse/Items/Item ")

  

  end


  defp parse_response_body(response) do
    response.body
  end


end

