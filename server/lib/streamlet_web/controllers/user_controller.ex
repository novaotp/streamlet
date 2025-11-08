defmodule StreamletWeb.UserController do
  use StreamletWeb, :controller

  alias Streamlet.Constants
  alias Streamlet.Models.User

  def me(%{req_cookies: req_cookies} = conn, _opts) do
    session_token = req_cookies[Constants.session_token_cookie_name()]

    case User.get_by_session_token(session_token) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{})
      user ->
        conn
        |> put_status(200)
        |> json(user)
    end
  end
end
