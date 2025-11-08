defmodule StreamletWeb.AuthController do
  use StreamletWeb, :controller

  alias Ecto.Changeset
  alias Streamlet.Constants
  alias Streamlet.Ecto.Errors
  alias Streamlet.Models.{Session,User}

  def register(%{body_params: body_params} = conn, _opts) do
    changeset = User.register_changeset(%User{}, body_params)

    with {:ok, user} <- User.create(changeset),
         {:ok, %Session{token: token}} <- Session.create_from_user(user) do
      conn
      |> put_status(201)
      |> add_session_cookie(token)
      |> json(%{
        message: "Registered successfully."
      })
    else
      {:error, invalid_changeset} ->
        errors = Errors.mapper(invalid_changeset)

        conn
        |> put_status(422)
        |> json(%{
          message: "Invalid data.",
          errors: errors
        })
    end
  end

  def login(%{body_params: body_params} = conn, _opts) do
    changeset = User.login_changeset(%User{}, body_params)

    with true <- changeset.valid?,
         email when email != nil <- Changeset.get_change(changeset, :email),
         %User{} = user <- User.get_by_email(email),
         password when password != nil <- Changeset.get_change(changeset, :password),
         true <- Bcrypt.verify_pass(password, user.password),
         {:ok, %Session{token: token}} <- Session.create_from_user(user) do
      conn
      |> put_status(200)
      |> add_session_cookie(token)
      |> json(%{
        message: "Logged in successfully."
      })
    else
      _ ->
        conn
        |> put_status(422)
        |> json(%{
          message: "Invalid email or password."
        })
    end
  end

  def logout(%{req_cookies: req_cookies} = conn, _opts) do
    session_token = req_cookies[Constants.session_token_cookie_name()]

    conn = if session_token != nil do
      Session.delete_by_token(session_token)

      conn
      |> delete_resp_cookie(
        Constants.session_token_cookie_name(),
        Constants.session_token_cookie_opts()
      )
    end

    conn |> send_resp(204, "")
  end

  defp add_session_cookie(conn, token) do
    conn
    |> put_resp_cookie(
      Constants.session_token_cookie_name(),
      token,
      Constants.session_token_cookie_opts()
    )
  end
end
