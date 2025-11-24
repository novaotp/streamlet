defmodule Streamlet.Schemas.Session do
  use Ecto.Schema

  import Ecto.Changeset
  alias Streamlet.Schemas.User

  @type t :: %__MODULE__{
        id: integer(),
        user_id: integer(),
        user: User.t() | Ecto.Association.NotLoaded.t(),
        token: String.t(),
        expires_at: DateTime.t(),
        inserted_at: DateTime.t(),
        updated_at: DateTime.t()
      }

  schema "sessions" do
    field :token, :string
    field :expires_at, :utc_datetime
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:user_id, :token, :expires_at])
    |> validate_required([:user_id, :token, :expires_at])
  end
end
