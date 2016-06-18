defmodule GetAmazon.Composer do
  @moduledoc """
  This module generates a valid http request to Amazon Advertising API. This request is signed folowing Amazon instructions.
  For more information visit http://docs.aws.amazon.com/AWSECommerceService/latest/DG/rest-signature.html
  """

  def generate_url(search_parameters) do
    query_string = generate_query_string(search_parameters)
    signature = generate_signature(query_string)
    url_params = Application.get_all_env(:amazon_url)

    "#{url_params[:APIProtocol]}://#{url_params[:APIBaseURL]}#{url_params[:APIBasePath]}?#{query_string}&Signature=#{signature}"
  end

  defp generate_signature(query_string) do
    query_string
    |> Security.create_signature
    |> URI.encode_www_form
  end

  defp generate_query_string(search_parameters) do
    search_parameters
    |> add_mandatory_parameters
    |> Enum.sort_by(fn({k,_})-> to_string(k) end) 
    |> URI.encode_query
  end

  defp add_mandatory_parameters(search_parameters) do
    mandatory_parameters =
      [
       Service:         Application.get_env(:amazon_parameters, :APIService),
       AWSAccessKeyId:  Application.get_env(:amazon_security, :AWSAccessKeyId),
       AssociateTag:    Application.get_env(:amazon_security, :AssociateTag),
       Version:         Application.get_env(:amazon_parameters, :APIVersion),
       Timestamp:       Time.get_current_utc_datestring()
      ]
    
    Enum.concat [mandatory_parameters, search_parameters]
  end
end
