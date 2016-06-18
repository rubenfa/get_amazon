defmodule Security do
  def create_signature(query_string) do

    security_params = Application.get_all_env(:amazon_security)
    url_params = Application.get_all_env(:amazon_url)

    str_to_sign = 
      [url_params[:APIMethod], url_params[:APIBaseURL], url_params[:APIBasePath], query_string]
      |> Enum.join("\n")

     :crypto.hmac(:sha256, security_params[:AWSAccessKey] , str_to_sign)
     |> Base.encode64
  end
end

