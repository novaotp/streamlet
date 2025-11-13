defmodule StreamletWeb.VideoController do
  use StreamletWeb, :controller

  alias Ecto.Changeset
  alias Streamlet.Ecto.Errors
  alias Streamlet.Models.Video
  alias Streamlet.S3

  def index(conn, _opts) do
    videos = Video.all()

    conn
    |> put_status(200)
    |> json(%{videos: videos})
  end

  def create(%{assigns: assigns} = conn, %{"title" => title, "description" => description, "video" => video}) do
    changeset = Video.changeset(%Video{}, %{
        user_id: assigns.user.id,
        title: title,
        description: description,
        filename: unique_filename(video.filename),
        content_type: video.content_type,
        size: fetch_file_size!(video.path)
      })

    with true <- changeset.valid?,
        {:ok, _} <- upload_video(changeset, video.path),
        {:ok, video_result} <- Video.create(changeset) do
      conn
      |> put_status(201)
      |> json(%{
        message: "Video uploaded successfully.",
        data: video_result
      })
    else
      false ->
        errors = Errors.mapper(changeset)

        conn
        |> put_status(422)
        |> json(%{
          message: "Invalid request.",
          errors: errors
        })
      {:error, _} ->
        conn
        |> put_status(500)
        |> json(%{
          message: "Internal server error."
        })
    end
  end

  defp upload_video(changeset, file_path) do
    user_id = Changeset.fetch_change!(changeset, :user_id)
    filename = Changeset.fetch_change!(changeset, :filename)

    S3.Videos.create(file_path, user_id, filename)
  end

  defp unique_filename(old_filename) do
    filename = UUID.uuid4()
    ext = Path.extname(old_filename)

    filename <> ext
  end

  defp fetch_file_size!(path) do
    path
    |> File.stat!
    |> Map.get(:size)
  end
end
