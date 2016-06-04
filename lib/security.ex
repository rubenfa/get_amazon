defmodule Security do
  def  add_security_keys(url) do
    url <>
      "&AWSAccessKeyId=" <> Application.get_env(:amazon_conf, :AWSAccessKeyId) <>
      "&AssociateTag=" <>    Application.get_env(:amazon_conf, :AssociateTag)    
  end
end

