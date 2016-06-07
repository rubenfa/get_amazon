defmodule GetAmazon.Composer do
  import Security

  @base_url Application.get_env(:amazon_conf, :APIBaseURL)

  def compose_url(filters) do
    applyFilters filters, add_security_keys(@base_url)    
  end
  
  defp applyFilters([head | tail], url ) do
    applyFilter head, applyFilters(tail, url)
  end

  defp applyFilters([], url) do
    url
  end

  defp applyFilter({name, value}, url) do
    url <> "&#{name}=#{value}"
  end

  # A unknown filter is ignored
  defp applyFilter(_, url) do
    url
  end
end
