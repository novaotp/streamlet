defmodule Streamlet.Contexts.Sessions do
  @moduledoc """
  The `Sessions` context handles all session-related operations.
  """

  import Ecto.Query

  alias Streamlet.Repo
  alias Streamlet.Schemas.{Session,User}

  @expires_at_days 14

  @spec get_user_by_session_token(token :: String.t()) :: {:ok, User.t()} | {:error, :not_found}
  def get_user_by_session_token(token) when is_binary(token) do
    query = from s in Session,
              where: s.token == ^token,
              preload: [:user]

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      session ->
        {:ok, session.user}
    end
  end
  def get_user_by_session_token(_), do: {:error, :not_found}

  @spec create_session_for_user(user :: User.t()) :: {:ok, Session.t()} | {:error, Ecto.Changeset.t()}
  def create_session_for_user(user) do
    attrs = %{
      user_id: user.id,
      token: UUID.uuid4(),
      expires_at: session_expires_at()
    }

    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  @spec delete_session_by_token(token :: String.t()) :: {non_neg_integer(), nil | [term()]}
  def delete_session_by_token(token) do
    query = from s in Session,
              where: s.token == ^token

    Repo.delete_all(query)
  end

  @spec session_expires_at() :: DateTime.t()
  defp session_expires_at() do
    DateTime.now!("Etc/UTC")
    |> DateTime.shift(day: @expires_at_days)
    |> DateTime.truncate(:second)
  end
end
