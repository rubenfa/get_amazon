defmodule GetAmazon.Composer do
  import Security

  @base_url Application.get_env(:amazon_conf, :APIBaseURL)

  def generate_url(filters) do
    create_filter_list(filters)
    |> add_mandatory_parameters
   end

  defp compose_url(filters) do
    add_security_keys(@base_url)
    #|> applyFilters filters_keys(@base_url)    
  end

  defp add_mandatory_parameters(filters) do
    [compose_value({:Service, Application.get_env(:amazon_conf, :APIService)}),
     compose_value({:AWSAccesKeyId, Application.get_env(:amazon_conf, :AWSAccesKeyId)}),
     compose_value({:AWSAccessKey, Application.get_env(:amazon_conf, :AWSAccessKey)}), 
     compose_value({:AssociateTag, Application.get_env(:amazon_conf, :AssociateTag)})]
    ++
    (filters

  end

  defp create_filter_list(parameters) do
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

  # defp applyFilters(url, [head | tail]) do
  #   applyFilter head, applyFilters(url, tail)
  # end

  # defp applyFilters(url, []) do
  #   url
  # end

  # defp applyFilter(url, {name, value}) do
  #   url <> "&#{name}=#{value}"
  # end

  # # A unknown filter is ignored
  # defp applyFilter(url, _) do
  #   url
  # end
end
