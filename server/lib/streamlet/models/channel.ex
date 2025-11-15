defmodule Streamlet.Models.Channel do
  @derive {Jason.Encoder, only: [
      :id,
      :user_id,
      :name,
      :slug,
      :description,
      :avatar_key,
      :banner_key,
      :is_verified
    ]}

  use Ecto.Schema
  import Ecto.Changeset

  alias Streamlet.{Models,Repo}

  schema "channels" do
    field :name, :string
    field :slug, :string
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
    |> validate_required([:user_id, :name, :slug, :description, :avatar_key, :banner_key, :is_verified])
    |> validate_slug()
    |> assoc_constraint(:user)
    |> unique_constraint(:slug)
  end

  def all() do
    Repo.all(__MODULE__)
  end

  def create(changeset) do
    Repo.insert(changeset)
  end

  defp validate_slug(changeset) do
    changeset
    |> validate_format(:slug, ~r/^(?!-)(?!.*--)(?!.*-$)[a-z0-9-]+$/)
  end
end
