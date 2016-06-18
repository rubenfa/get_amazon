defmodule GetAmazon.Composer do
 
  def generate_url(search_parameters) do

    query_string =
      search_parameters
      |> to_ordered_query_string_list
      |> URI.encode_query

    signature =
      query_string
      |> Security.create_signature
      |> URI.encode_www_form

    url_params = Application.get_all_env(:amazon_url)

    "#{url_params[:APIProtocol]}://#{url_params[:APIBaseURL]}#{url_params[:APIBasePath]}?#{query_string}&Signature=#{signature}"

  end

  def to_ordered_query_string_list(search_parameters) do
    search_parameters
    |> add_mandatory_parameters    
    |> Enum.sort_by(fn({k,v})-> to_string(k) end)
  end

  defp add_mandatory_parameters(search_parameters) do
    [{:Service, Application.get_env(:amazon_parameters, :APIService)},
     {:AWSAccessKeyId, Application.get_env(:amazon_security, :AWSAccessKeyId)},
     {:AssociateTag, Application.get_env(:amazon_security, :AssociateTag)},
     {:Version, Application.get_env(:amazon_parameters, :APIVersion)},
     {:Timestamp, Time.get_current_utc_datestring() }
    ]
    ++
    (search_parameters)
  end
end
