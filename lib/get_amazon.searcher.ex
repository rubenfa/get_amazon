defmodule GetAmazon.Searcher do

  alias GetAmazon.Composer
  
  def search(filters) do
    HTTPoison.start

    Composer.compose_url(filters)
    |> HTTPoison.get!
    |> parse_response_body
    |> Floki.find("body")
   # |> Floki.text

  end


  defp parse_response_body(response) do
    response.body
  end


end

