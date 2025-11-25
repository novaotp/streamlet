defmodule Streamlet.Contexts.Channels do
  import Streamlet.S3.Constants, only: [channel_avatar_bucket: 0, path: 1]

  alias Streamlet.Schemas.Channel
  alias Streamlet.Repo

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

  @spec update_channel(id :: integer(), user_id :: integer(), attrs :: map()) :: {:ok, Channel.t()} | {:error, :forbidden | Ecto.Changeset.t()}
  def update_channel(id, user_id, attrs) do
    with {:ok, channel} <- get_channel(id),
         true <- channel.user_id == user_id,
         changeset <- Channel.update_changeset(channel, attrs),
         {:ok, updated_channel} <- Repo.update(changeset) do
      {:ok, updated_channel}
    else
      false ->
        {:error, :forbidden}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec delete_channel(id :: integer(), user_id :: integer()) :: {:ok, nil} | {:error, :forbidden | Ecto.Changeset.t()}
  def delete_channel(id, user_id) do
    with {:ok, channel} <- get_channel(id),
         true <- channel.user_id == user_id,
         {:ok, _} <- Repo.delete(channel) do
      {:ok, nil}
    else
      false ->
        {:error, :forbidden}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp with_avatar_path(%Channel{} = channel) do
    %{channel | avatar_path: avatar_path(channel)}
  end
  defp with_avatar_path(_), do: nil

  defp avatar_path(%Channel{avatar_key: nil}), do: nil
  defp avatar_path(%Channel{} = channel) do
    url = path(channel_avatar_bucket())

    url <> "/#{channel.user_id}/#{channel.avatar_key}"
  end
end
