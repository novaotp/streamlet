defmodule Streamlet.Models.Video do
  @derive {Jason.Encoder, only: [
      :id,
      :user_id,
      :title,
      :description,
      :filename,
      :inserted_at,
      :resource_path
    ]}

  use Ecto.Schema
  import Ecto.Changeset

  alias Streamlet.S3.Constants
  alias Streamlet.{Models,Repo}

  schema "videos" do
    field :title, :string
    field :description, :string
    field :filename, :string
    field :content_type, :string
    field :size, :integer
    field :resource_path, :string, virtual: true

    belongs_to :user, Models.User

    timestamps(type: :utc_datetime)
  end

  @allowed_content_types ["video/mp4", "video/mkv"]
  @min_title_length 1
  @max_title_length 50

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:user_id, :title, :description, :filename, :content_type, :size])
    |> validate_required([:user_id, :title, :description, :filename, :content_type, :size])
    |> validate_length(:title, min: @min_title_length, max: @max_title_length)
    |> validate_inclusion(:content_type, @allowed_content_types)
    |> assoc_constraint(:user)
  end

  def all() do
    __MODULE__
    |> Repo.all
    |> Enum.map(&with_resource_path/1)
  end

  def create(changeset) do
    with {:ok, video} <- Repo.insert(changeset) do
      {:ok, with_resource_path(video)}
    else
      other -> other
    end
  end

  defp with_resource_path(%__MODULE__{} = video) do
    path = Constants.videos_bucket |> Constants.path
    resource_path = "#{path}/#{video.user_id}/#{video.filename}"

    %{video | resource_path: resource_path}
  end
end
