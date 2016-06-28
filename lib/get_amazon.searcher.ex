defmodule GetAmazon.Searcher do
 
  alias GetAmazon.Composer
  alias GetAmazon.RequestProcessor
  
  def search(filters) do
    HTTPoison.start

    Composer.generate_url(filters)
    |> HTTPoison.get!
    |> parse_response_body
    |> RequestProcessor.get_items
  end

  defp parse_response_body(response) do
    response.body
  end

end

