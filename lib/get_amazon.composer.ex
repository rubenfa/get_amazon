defmodule GetAmazon.Composer do
  import Security
  import Time

  @base_url Application.get_env(:amazon_conf, :APIBaseURL)

  def generate_url(search_parameters) do
   generate_query_parameters_list []
  end

  defp generate_query_parameters_list(search_parameters) do
    search_parameters
    |> add_mandatory_parameters
    |> encode
   # |> Enum.map (fn({k, v}) -> {k, URI.encode(v)} end)
  end

  defp add_mandatory_parameters(filters) do
    timestamp = Time.get_current_utc_datestring() 

    [{:Service, Application.get_env(:amazon_conf, :APIService)},
     {:AWSAccesKeyId, Application.get_env(:amazon_conf, :AWSAccesKeyId)},
     {:AWSAccessKey, Application.get_env(:amazon_conf, :AWSAccessKey)}, 
     {:AssociateTag, Application.get_env(:amazon_conf, :AssociateTag)},
     {:Timestamp, timestamp }
    ]
    ++
    (filters)
  end

  # defp create_parameter_list(parameters) do
  #   filter_compose [], parameters
  # end

  # defp compose_value({name, value}) do
  #   "#{name}=#{value}"
  # end

  # defp compose_encoded_value({name, value}) do
  #   encoded_value = URI.encode(value)

  #   "#{name}=#{encoded_value}"
  # end

  defp encode(parameters) do
    for {k, v} <- parameters, do: {k, URI.encode(v)}      
  end


  
  # defp filter_compose(result,[ head | tail]) do
  #   updated_result = [ compose_encoded_value(head) | result]
  #   filter_compose updated_result ,  tail
  # end

  # defp filter_compose(result, []) do
  #   result
  # end

end
