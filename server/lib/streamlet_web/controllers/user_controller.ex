defmodule StreamletWeb.UserController do
  use StreamletWeb, :controller

  def me(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{
        data: conn.assigns.user
      })
  end
end
