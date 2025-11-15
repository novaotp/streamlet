defmodule StreamletWeb.ChannelController do
  use StreamletWeb, :controller

  alias Streamlet.Ecto.Errors
  alias Streamlet.Helpers.File, as: FileHelper
  alias Streamlet.Models.Channel

  def index(conn, _opts) do
    channels = Channel.all()

    conn
    |> put_status(200)
    |> json(%{
      data: channels
    })
  end

  def show(conn, _opts) do
    conn
    |> put_status(:not_implemented)
    |> json(%{
      message: "Method not implemented yet."
    })
  end

  def create(%{assigns: assigns} = conn, opts) do
    %{
      "name" => name,
      "handle" => handle,
      "description" => description,
      "avatar" => avatar,
      "banner" => banner
    } = opts

    changeset = Channel.changeset(%Channel{}, %{
        user_id: assigns.user.id,
        name: name,
        handle: handle,
        description: description,
        avatar_key: avatar |> upload_filename |> FileHelper.unique_filename,
        banner_key: banner |> upload_filename |> FileHelper.unique_filename,
      })

    with true <- changeset.valid?,
         {:ok, channel} <- Channel.create(changeset) do
      conn
      |> put_status(:created)
      |> json(%{
        message: "Channel created successfully.",
        data: channel
      })
    else
      false ->
        errors = Errors.mapper(changeset)

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          message: "Invalid data.",
          errors: errors
        })
      {:error, _} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{
          message: "Internal server error."
        })
    end
  end

  def update(conn, _opts) do
    conn
    |> put_status(:not_implemented)
    |> json(%{
      message: "Method not implemented yet."
    })
  end

  def delete(conn, _opts) do
    conn
    |> put_status(:not_implemented)
    |> json(%{
      message: "Method not implemented yet."
    })
  end

  defp upload_filename("null"), do: nil
  defp upload_filename(%Plug.Upload{} = upload), do: upload.filename
end
