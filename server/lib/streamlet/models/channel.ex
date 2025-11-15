defmodule Streamlet.Models.Channel do
  @derive {Jason.Encoder, only: [
      :id,
      :user_id,
      :name,
      :handle,
      :description,
      :avatar_key,
      :banner_key,
      :is_verified
    ]}

  use Ecto.Schema

  import Ecto.Changeset
  import Streamlet.S3.Constants, only: [channel_avatar_bucket: 0, path: 1]

  alias Streamlet.{Models,Repo}

  schema "channels" do
    field :name, :string
    field :handle, :string
    field :description, :string
    field :avatar_key, :string
    field :banner_key, :string
    field :is_verified, :boolean, default: false

    field :avatar_path, :string, virtual: true
    field :banner_path, :string, virtual: true

    belongs_to :user, Models.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(channels, attrs) do
    channels
    |> cast(attrs, [:user_id, :name, :description, :avatar_key, :banner_key])
    |> validate_required([:user_id, :name, :handle, :description, :is_verified])
    |> validate_handle()
    |> assoc_constraint(:user)
    |> unique_constraint(:handle)
  end

  def all() do
    __MODULE__
    |> Repo.all
    |> Enum.map(&with_avatar_path/1)
  end

  def create(changeset) do
    with {:ok, channel} <- Repo.insert(changeset) do
      {:ok, with_avatar_path(channel)}
    else
      other -> other
    end
  end

  defp validate_handle(changeset) do
    changeset
    |> validate_format(:handle, ~r/^(?!_)(?!.*__)(?!.*_$)[a-zA-Z0-9_]+$/)
  end

  defp with_avatar_path(%__MODULE__{} = channel) do
    %{channel | avatar_path: avatar_path(channel)}
  end

  defp avatar_path(%__MODULE__{avatar_key: nil}), do: nil
  defp avatar_path(%__MODULE__{} = channel) do
    url = path(channel_avatar_bucket())

    url <> "/#{channel.user_id}/#{channel.avatar_key}"
  end
end
