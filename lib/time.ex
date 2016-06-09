defmodule Time do
  use Timex 

  def get_utc_date_string() do
    currentDate = Date.now

    Timex.format(currentDate, "{ISO:Extended}")
  end
end
