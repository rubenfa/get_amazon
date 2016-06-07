defmodule GetAmazon.Searcher do

  alias GetAmazon.Composer
  

  def search(filters) do
    HTTPoison.start
    url =  Composer.compose_url filters

    HTTPoison.get! url
  end
end
