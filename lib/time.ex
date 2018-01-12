defmodule Time do
  @moduledoc """
  To get datetimes in a specific format
  """

  import Chronos

  def get_current_utc_datestring do
    #    Chronos.Formatter.strftime(Chronos.now ,  "%Y-%0m-%0dT%H:%M:%S.000Z")
    Chronos.Formatter.iso8601(Chronos.now())
  end
end
