defmodule GetAmazon.Composer do
 
  def generate_url(search_parameters) do

    query_string =
      search_parameters
      |> to_query_string_list
      |> to_query_string

    signature =
      query_string
      |> Security.create_signature
      |> URI.encode

    url_params = Application.get_all_env(:amazon_url)

    "#{url_params[:APIProtocol]}://#{url_params[:APIBaseURL]}#{url_params[:APIBasePath]}?#{query_string}&Signature=#{signature}"

  end


  def to_query_string_list(search_parameters) do
    search_parameters
    |> add_mandatory_parameters
    |> encode_parameters
    |> Enum.sort_by(fn({k,v})-> to_string(k) end)
  end

  defp add_mandatory_parameters(search_parameters) do
    [{:Service, Application.get_env(:amazon_parameters, :APIService)},
     {:AWSAccessKeyId, Application.get_env(:amazon_security, :AWSAccessKeyId)},
     {:AssociateTag, Application.get_env(:amazon_security, :AssociateTag)},
     {:Timestamp, Time.get_current_utc_datestring() }
    ]
    ++
    (search_parameters)
  end

  defp to_query_string(parameters) do
    parameters
    |> Enum.map_join "&", fn(x)-> compose_value(x)  end
  end

  defp compose_value({name, value}) do
    "#{name}=#{value}"
  end

  defp encode_parameters(parameters) do
    for {k, v} <- parameters, not is_nil(v),  do:   {k, URI.encode(v)}
  end

end
