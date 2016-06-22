defmodule GetAmazon.Security do
  @moduledoc  """
  Generates a signature token using a url query string
  ## Example query_string
    Operation="SearchItem"&SearchIndex=Electronics
  """

  def create_signature(query_string, security_parameters) do    

    [security_parameters[:APIMethod], security_parameters[:APIBaseURL], security_parameters[:APIBasePath], query_string]
    |> Enum.join("\n")
    |> sign_string (security_parameters[:AWSAccessKey])
  end

  defp sign_string(str_to_sign, access_key) do
    :crypto.hmac(:sha256, access_key, str_to_sign)
    |> Base.encode64
  end
end

