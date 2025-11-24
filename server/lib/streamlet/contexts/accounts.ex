defmodule Streamlet.Contexts.Accounts do
  @moduledoc """
  The `Accounts` context handles all account-related operations (users, sessions).
  """

  alias Streamlet.Contexts.Sessions
  alias Streamlet.Repo
  alias Streamlet.Schemas.User

  @spec register_user(attrs :: map()) :: {:ok, String.t()} | {:error, Ecto.Changeset.t()}
  def register_user(attrs) do
    with {:ok, user} <- create_user(attrs),
         {:ok, session} <- Sessions.create_session_for_user(user) do
      {:ok, session.token}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec login_user(attrs :: map()) :: {:ok, String.t()} | {:error, :unauthorized}
  def login_user(%{"email" => email, "password" => password}) do
    with %User{} = user <- get_user_by_email(email),
         true <- Bcrypt.verify_pass(password, user.password),
         {:ok, session} = Sessions.create_session_for_user(user) do
      {:ok, session.token}
    else
      _ ->
        {:error, :unauthorized}
    end
  end
  def login_user(_), do: {:error, :unauthorized}

  @spec get_user_by_email(email :: String.t()) :: User.t() | nil
  defp get_user_by_email(email) do
    Repo.get_by(User, [email: email])
  end

  @spec create_user(attrs :: map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  defp create_user(attrs) do
    %User{}
    |> User.register_changeset(attrs)
    |> Repo.insert()
  end
end
