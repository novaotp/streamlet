defmodule Streamlet.AuthHelpers do
  import Plug.Conn
  import Phoenix.ConnTest

  alias Streamlet.User

  # Creates a user using your real context logic
  def register_test_user() do
    attrs = %{
      email: "user#{System.unique_integer()}@example.com",
      password: "password123"
    }

    {:ok, user} =
      %User{}
      |> User.register_changeset(attrs)
      |> User.create()

    user
  end

  # Logs in by generating a session token or API token
  # (depends on how your system works)
  def authenticate(conn, user) do
    token = Accounts.generate_user_session_token(user)

    conn
    |> put_req_header("authorization", "Bearer " <> token)
  end
end
