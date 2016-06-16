defmodule Security do
  def create_signature(method, base_url, path, query_string) do

    str_to_sign = """
    #{method}
    #{base_url}
    #{path}
    #{query_string}
    """

    :crypto.hmac(:sha256, "key", str_to_sign)
    |> Base.encode16    
  end

end

