defmodule GetAmazon.Composer do
  import Security
  import Time

  @base_url Application.get_env(:amazon_conf, :APIBaseURL)

  def generate_url(search_parameters) do
   generate_query_parameters_list []
  end

  defp generate_query_parameters_list(search_parameters) do
    create_parameter_list(search_parameters)
    |> add_mandatory_parameters
  end

  defp add_mandatory_parameters(filters) do
    timestamp = Time.get_utc_date_string()


    [compose_value({:Service, Application.get_env(:amazon_conf, :APIService)}),
     compose_value({:AWSAccesKeyId, Application.get_env(:amazon_conf, :AWSAccesKeyId)}),
     compose_value({:AWSAccessKey, Application.get_env(:amazon_conf, :AWSAccessKey)}), 
     compose_value({:AssociateTag, Application.get_env(:amazon_conf, :AssociateTag)}),
     compose_value({:Timestamp, timestamp })
    ]
    ++
    (filters)
  end

  defp create_parameter_list(parameters) do
    filter_compose [], parameters
  end

  defp compose_value({name, value}) do
    "#{name}=#{value}"
  end

  defp filter_compose(result,[ head | tail]) do
    updated_result = [ compose_value(head) | result]
    filter_compose updated_result ,  tail
  end

  defp filter_compose(result, []) do
    result
  end

end
