defmodule StreamletWeb.PingController do
  use StreamletWeb, :controller

  def ping(conn, _params) do
    json(conn, %{message: "pong"})
  end
end
