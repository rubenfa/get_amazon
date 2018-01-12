defmodule GetAmazon.Searcher do
  @moduledoc """
  Used request Amazon API, adding all stuff necessary.
  """

  alias GetAmazon.Composer
  alias GetAmazon.RequestProcessor

  def search(filters) do
    HTTPoison.start()

    result =
      filters
      |> Composer.generate_url()
      |> HTTPoison.get!()
      |> parse_response_body
      |> RequestProcessor.get_items()
  end

  def xml_search_to_file(path, filters) do
    HTTPoison.start()

    body =
      filters
      |> Composer.generate_url()
      |> HTTPoison.get!()
      |> parse_response_body

    File.write(path, body)
  end

  def parsed_search_to_file(path, filters) do
    HTTPoison.start()

    items =
      filters
      |> Composer.generate_url()
      |> HTTPoison.get!()
      |> parse_response_body
      |> RequestProcessor.get_items()

    File.write(path, items)
  end

  defp parse_response_body(response) do
    response.body
  end
end
