defmodule Streamlet.Schemas.Channel do
  @derive {Jason.Encoder, only: [
      :id,
      :user_id,
      :name,
      :handle,
      :description,
      :avatar_key,
      :banner_key,
      :is_verified,
      :avatar_path,
      :banner_path
    ]}

  use Ecto.Schema

  import Ecto.Changeset
  alias Streamlet.Schemas.User

  @type t :: %__MODULE__{
          id: integer(),
          user_id: integer() | nil,
          user: User.t() | Ecto.Association.NotLoaded.t(),
          name: String.t(),
          handle: String.t(),
          is_verified: boolean(),
          description: String.t() | nil,
          avatar_key: String.t() | nil,
          banner_key: String.t() | nil,
          avatar_path: String.t() | nil,
          banner_path: String.t() | nil,
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "channels" do
    field :name, :string
    field :handle, :string
    field :description, :string
    field :avatar_key, :string
    field :banner_key, :string
    field :is_verified, :boolean, default: false

    field :avatar_path, :string, virtual: true
    field :banner_path, :string, virtual: true

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:user_id, :name, :handle, :description])
    |> validate_required([:user_id, :name, :handle, :is_verified])
    |> validate_handle()
    |> assoc_constraint(:user)
    |> unique_constraint(:handle)
  end

  @doc false
  def update_changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name, :handle, :description])
    |> validate_required([:user_id, :name, :handle, :is_verified])
    |> validate_handle()
    |> unique_constraint(:handle)
  end

  @doc false
  def update_avatar_changeset(channel, attrs) do
    channel
    |> cast(attrs, [:avatar_key])
  end

  @spec validate_handle(changeset :: Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_handle(changeset) do
    changeset
    |> validate_format(:handle, ~r/\A[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+)*\z/)
  end
end
