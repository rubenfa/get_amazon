defmodule GetAmazon.Composer do
  import Security

  @base_url Application.get_env(:amazon_conf, :APIBaseURL)

  def compose_url(filters) do
    add_security_keys(@base_url)
    |> applyFilters filters_keys(@base_url)    
  end

  defp add_mandatory_parameters(filters) do
    [{:Service, Application.get_env(:amazon_conf, :APIService)}| filters]
  end

  defp add_signature(filters) do

  end

  defp filter_compose(result,[ {name, value} | tail]) do
    filter_compose ( ["#{name}=#{value}" | result], head), tail)
  end

  defp filter_compose(result, {name, value}) do
     | result]
  end

  defp filter_compose(result, []) do
    result
  end

  defp applyFilters(url, [head | tail]) do
    applyFilter head, applyFilters(url, tail)
  end

  defp applyFilters(url, []) do
    url
  end

  defp applyFilter(url, {name, value}) do
    url <> "&#{name}=#{value}"
  end

  # A unknown filter is ignored
  defp applyFilter(url, _) do
    url
  end
end
