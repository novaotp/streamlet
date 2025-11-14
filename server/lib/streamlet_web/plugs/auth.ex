defmodule StreamletWeb.Plugs.Auth do
  use StreamletWeb, :controller

  alias Streamlet.Constants
  alias Streamlet.Models.User

  def init(opts), do: opts

  def call(conn, _opts) do
    with cookies <- get_cookies(conn),
         session_token when is_binary(session_token) <- session_token_from_cookies(cookies),
         %User{} = user <- User.get_by_session_token(session_token) do
      assign(conn, :user, user)
    else
      _ ->
        conn
        |> put_status(401)
        |> json(%{
          message: "You must be authenticated."
        })
        |> halt()
    end
  end

  defp session_token_from_cookies(cookies) do
    cookies |> Map.get(Constants.session_token_cookie_name())
  end
end
