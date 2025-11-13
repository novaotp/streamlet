defmodule Streamlet.Models.User do
  @derive {Jason.Encoder, only: [:username, :email, :inserted_at]}

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Streamlet.{Models,Repo}

  schema "users" do
    field :username, :string, default: nil
    field :email, :string
    field :password, :string, redact: true

    has_many :sessions, Models.Session
    has_many :videos, Models.Video

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
    |> validate_username_length()
    |> unique_constraint(:email)
    |> replace_with_password_hash()
  end

  @doc false
  def login_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
  end

  def create(changeset) do
    Repo.insert(changeset)
  end

  def get_by_email(email) do
    Repo.get_by(__MODULE__, [email: email])
  end

  def get_by_session_token(nil), do: nil
  def get_by_session_token(token) do
    query = from s in Models.Session,
              where: s.token == ^token,
              preload: [:user]

    query
    |> Repo.one
    |> get_by_session
  end

  defp get_by_session(%Models.Session{} = session), do: session.user
  defp get_by_session(_), do: nil

  defp validate_username_length(user) do
    if Map.has_key?(user, :username) do
      user |> validate_length(:username, min: @min_username_length)
    else
      user
    end
  end

  defp replace_with_password_hash(changeset) do
    with password <- get_change(changeset, :password),
         true <- changeset.valid? do
      hashed_password = Bcrypt.hash_pwd_salt(password)

      changeset |> put_change(:password, hashed_password)
    else
      nil -> changeset
      false -> changeset
    end
  end
end
