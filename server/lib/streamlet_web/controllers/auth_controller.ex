defmodule StreamletWeb.AuthController do
  use StreamletWeb, :controller

  alias Streamlet.Constants
  alias Streamlet.Contexts.{Accounts,Sessions}
  alias Streamlet.Ecto.Errors

  def register(conn, _params) do
    case Accounts.register_user(conn.body_params) do
      {:ok, token} ->
        conn
        |> put_status(:created)
        |> add_session_cookie(token)
        |> json(%{
          message: "Registered successfully."
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          message: "Invalid data.",
          errors: Errors.mapper(changeset)
        })
    end
  end

  def login(conn, _params) do
    case Accounts.login_user(conn.body_params) do
      {:ok, token} ->
        conn
        |> put_status(:ok)
        |> add_session_cookie(token)
        |> json(%{
          message: "Logged in successfully."
        })

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{
          message: "Invalid email or password."
        })
    end
  end

  def logout(conn, _params) do
    conn
    |> maybe_delete_session()
    |> remove_session_cookie()
    |> send_resp(204, "")
  end

  @spec maybe_delete_session(conn :: Plug.Conn.t()) :: Plug.Conn.t()
  defp maybe_delete_session(conn) do
    token =
      conn
      |> get_cookies()
      |> Map.get(Constants.session_token_cookie_name())

    if token, do: Sessions.delete_session_by_token(token)

    conn
  end

  @spec add_session_cookie(conn :: Plug.Conn.t(), token :: String.t()) :: Plug.Conn.t()
  defp add_session_cookie(conn, token) do
    conn
    |> put_resp_cookie(
        Constants.session_token_cookie_name(),
        token,
        Constants.session_token_cookie_opts()
      )
  end

  @spec remove_session_cookie(conn :: Plug.Conn.t()) :: Plug.Conn.t()
  defp remove_session_cookie(conn) do
    conn
    |> delete_resp_cookie(
        Constants.session_token_cookie_name(),
        Constants.session_token_cookie_opts()
      )
  end
end
