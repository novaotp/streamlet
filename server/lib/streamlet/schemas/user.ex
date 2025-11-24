defmodule Streamlet.Schemas.User do
  @derive {Jason.Encoder, only: [:username, :email, :inserted_at]}

  use Ecto.Schema

  import Ecto.Changeset
  alias Streamlet.Schemas.Session

  @type t :: %__MODULE__{
          id: integer(),
          email: String.t(),
          username: String.t() | nil,
          password: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t(),
          sessions: [Session.t()] | Ecto.Association.NotLoaded.t()
        }

  schema "users" do
    field :username, :string, default: nil
    field :email, :string
    field :password, :string, redact: true
    has_many :sessions, Session

    timestamps(type: :utc_datetime)
  end

  @min_username_length 3
  @min_password_length 8
  @max_password_length 50

  @doc false
  def register_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: @min_password_length, max: @max_password_length)
    |> validate_length(:username, min: @min_username_length)
    |> unique_constraint(:email)
    |> replace_with_password_hash()
  end

  @spec replace_with_password_hash(changeset :: Changeset.t()) :: Changeset.t()
  defp replace_with_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        put_change(changeset, :password, Bcrypt.hash_pwd_salt(password))
    end
  end
end
