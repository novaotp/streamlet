defmodule Streamlet.Support.AuthFixtures do
  import Phoenix.ConnTest

  alias Streamlet.Constants
  alias Streamlet.Contexts.Sessions
  alias Streamlet.Schemas.User
  alias Streamlet.Repo

  @doc """
  Creates and returns a user with sensible default attributes.
  """
  @spec user_fixture(attrs :: map()) :: User.t()
  def user_fixture(attrs \\ %{}) do
    valid_attrs = %{
      email: "user#{System.unique_integer()}@example.com",
      password: "password123"
    }

    attrs = Map.merge(valid_attrs, attrs)

    {:ok, user} =
      %User{}
      |> User.register_changeset(attrs)
      |> Repo.insert()

    user
  end

  @doc """
  Logs the given user in by creating a session and setting the session token as
  a request cookie.
  """
  @spec log_in_user(conn :: Plug.Conn.t(), user :: User.t()) :: Plug.Conn.t()
  def log_in_user(conn, user) do
    {:ok, session} = Sessions.create_session_for_user(user)

    conn
    |> put_req_cookie(Constants.session_token_cookie_name(), session.token)
  end
end
