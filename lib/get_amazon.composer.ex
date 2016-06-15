defmodule GetAmazon.Composer do
 
  @base_url Application.get_env(:amazon_conf, :APIBaseURL)

  def generate_url(search_parameters) do
   generate_query_parameters_list search_parameters
  end

  defp generate_query_parameters_list(search_parameters) do
    search_parameters
    |> add_mandatory_parameters
    |> encode  
  end

  defp add_mandatory_parameters(filters) do
    [{:Service, Application.get_env(:amazon_conf, :APIService)},
     {:AWSAccessKeyId, Application.get_env(:amazon_conf, :AWSAccessKeyId)},
     {:AWSAccessKey, Application.get_env(:amazon_conf, :AWSAccessKey)}, 
     {:AssociateTag, Application.get_env(:amazon_conf, :AssociateTag)},
     {:Timestamp, Time.get_current_utc_datestring() }
    ]
    ++
    (filters)
  end

  defp compose_value({name, value}) do
    "#{name}=#{value}"
  end

  defp encode(parameters) do
    for {k, v} <- parameters, not is_nil(v),  do: {k, URI.encode(v)}      
  end

end
