defmodule StreamletWeb.Plugs.Auth do
  use StreamletWeb, :controller

  alias Streamlet.Constants
  alias Streamlet.Contexts.Sessions

  def init(opts), do: opts

  def call(conn, _opts) do
    token = get_session_token(conn)

    case Sessions.get_user_by_session_token(token) do
      {:ok, user} ->
        assign(conn, :user, user)

      {:error, :not_found} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{
            message: "You must be authenticated."
          })
        |> halt()
    end
  end

  @spec get_session_token(conn :: Plug.Conn.t()) :: String.t() | nil
  defp get_session_token(conn) do
    conn
    |> get_cookies()
    |> Map.get(Constants.session_token_cookie_name())
  end
end
