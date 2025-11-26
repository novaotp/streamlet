defmodule Streamlet.Contexts.Channels do
  import Streamlet.S3.Constants, only: [channel_avatars_bucket: 0, path: 1]

  alias Streamlet.Schemas.Channel
  alias Streamlet.Repo

  defdelegate authorize(action, user, params), to: Streamlet.Contexts.Channels.Policy

  @spec list_all() :: [Channel.t()]
  def list_all() do
    Channel
    |> Repo.all()
    |> Enum.map(&with_avatar_path/1)
  end

  @spec get_channel(id :: integer()) :: {:ok, Channel.t()} | {:error, :not_found}
  def get_channel(id) do
    case Repo.get(Channel, id) do
      nil ->
        {:error, :not_found}

      channel ->
        {:ok, with_avatar_path(channel)}
    end
  end

  @spec create_channel(attrs :: map()) :: {:ok, Channel.t()} | {:error, Ecto.Changeset.t()}
  def create_channel(attrs) do
    changeset = Channel.changeset(%Channel{}, attrs)

    case Repo.insert(changeset) do
      {:ok, channel} ->
        {:ok, with_avatar_path(channel)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec update_channel(channel :: Channel.t(), attrs :: map()) :: {:ok, Channel.t()} | {:error, Ecto.Changeset.t()}
  def update_channel(channel, attrs) do
    changeset = Channel.update_changeset(channel, attrs)

    case Repo.update(changeset) do
      {:ok, updated_channel} ->
        {:ok, with_avatar_path(updated_channel)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec update_channel_avatar(channel :: Channel.t(), avatar_key :: String.t() | nil) :: {:ok, Channel.t()} | {:error, Ecto.Changeset.t()}
  def update_channel_avatar(channel, avatar_key) do
    changeset = Channel.update_avatar_changeset(channel, %{avatar_key: avatar_key})

    case Repo.update(changeset) do
      {:ok, updated_channel} ->
        {:ok, with_avatar_path(updated_channel)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec delete_channel(channel :: Channel.t()) :: {:ok, Channel.t()} | {:error, Ecto.Changeset.t()}
  def delete_channel(channel) do
    Repo.delete(channel)
  end

  @spec with_avatar_path(Channel.t()) :: Channel.t()
  defp with_avatar_path(channel) do
    case channel.avatar_key do
      nil ->
        %{channel | avatar_path: nil}

      key ->
        base = path(channel_avatars_bucket())
        path = Path.join([base, "#{channel.user_id}", key])

        %{channel | avatar_path: path}
    end
  end
end
