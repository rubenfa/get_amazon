defmodule GetAmazon.Composer do
  @moduledoc """
  This module generates a valid http request for Amazon Advertising API. This request is signed folowing Amazon instructions.
  For more information visit [Amazon Advertising API documentation](http://docs.aws.amazon.com/AWSECommerceService/latest/DG/rest-signature.html)

  ## Valid search_pabrameters input
  [Operation: "ItemSearch", SearchIndex: "Electronics", Keywords: "Lenovo", ResponseGroup: "Images,ItemAttributes,Offers"]
  """

  alias GetAmazon.Security

  alias Application, as: App

  def generate_url(search_parameters) do
    search_parameters
    |> generate_query_string
    |> append_signature
    |> append_url_base
  end

  defp append_url_base(full_query) do
    url_params = App.get_all_env(:amazon_url)

    "#{url_params[:APIProtocol]}://#{url_params[:APIBaseURL]}#{url_params[:APIBasePath]}#{
      full_query
    }"
  end

  defp append_signature(query_string) do
    signature = generate_signature(query_string)

    "?#{query_string}&Signature=#{signature}"
  end

  defp generate_signature(query_string) do
    query_string
    |> Security.create_signature(
      App.get_all_env(:amazon_url) ++ App.get_all_env(:amazon_security)
    )
    |> URI.encode_www_form()
  end

  defp generate_query_string(search_parameters) do
    search_parameters
    |> add_mandatory_parameters
    |> Enum.sort_by(fn {k, _} -> to_string(k) end)
    |> URI.encode_query()
  end

  defp add_mandatory_parameters(search_parameters) do
    mandatory_parameters = [
      Service: App.get_env(:amazon_parameters, :APIService),
      AWSAccessKeyId: App.get_env(:amazon_security, :AWSAccessKeyId),
      AssociateTag: App.get_env(:amazon_security, :AssociateTag),
      Version: App.get_env(:amazon_parameters, :APIVersion),
      Timestamp: Time.get_current_utc_datestring()
    ]

    Enum.concat([mandatory_parameters, search_parameters])
  end
end
