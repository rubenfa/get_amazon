defmodule Security do
  @moduledoc  """
  Generates a signature token using a url query string
  """

  def create_signature(query_string) do    
    url_params = Application.get_all_env(:amazon_url)

    [url_params[:APIMethod], url_params[:APIBaseURL], url_params[:APIBasePath], query_string]
    |> Enum.join("\n")
    |>sign_string
  end

  defp sign_string(str_to_sign) do
    :crypto.hmac(:sha256, Application.get_env(:amazon_security, :AWSAccessKey), str_to_sign)
    |> Base.encode64
  end
end

