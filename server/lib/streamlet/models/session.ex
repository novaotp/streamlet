defmodule Streamlet.Models.Session do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Streamlet.{Models,Repo}

  schema "sessions" do
    field :token, :string
    field :expires_at, :utc_datetime
    belongs_to :user, Models.User

    timestamps(type: :utc_datetime)
  end

  @expires_at_days 14

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [])
    |> validate_required([])
  end

  def create_from_user(user) do
    token = UUID.uuid4()

    session = %__MODULE__{
      user_id: user.id,
      token: token,
      expires_at: session_expires_at()
    }

    Repo.insert(session)
  end

  def delete_by_token(token) do
    query = from s in __MODULE__,
              where: s.token == ^token

    Repo.delete_all(query)
  end

  defp session_expires_at() do
    DateTime.now!("Etc/UTC")
    |> DateTime.shift(day: @expires_at_days)
    |> DateTime.truncate(:second)
  end
end
