defmodule StreamletWeb.ChannelController do
  use StreamletWeb, :controller

  alias Streamlet.Contexts.Channels
  alias Streamlet.Ecto.Errors
  alias Streamlet.Helpers.File, as: FileHelper

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{
      data: Channels.list_all()
    })
  end

  def show(conn, %{"id" => id}) do
    case Channels.get_channel(id) do
      {:ok, channel} ->
        conn
        |> put_status(:ok)
        |> json(%{
          data: channel
        })

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{
          message: "Channel not found."
        })
    end
  end

  def create(conn, params) do
    attrs = %{params | "user_id" => conn.assigns.user.id}

    case Channels.create_channel(attrs) do
      {:ok, channel} ->
        conn
        |> put_status(:created)
        |> json(%{
          message: "Channel created successfully.",
          data: channel
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          message: "Invalid data.",
          errors: Errors.mapper(changeset)
        })
    end
  end

  def update(conn, %{"id" => id}) do
    case Channels.update_channel(id, conn.assigns.user.id, conn.body_params) do
      {:ok, channel} ->
        conn
        |> put_status(:ok)
        |> json(%{
          message: "Channel updated successfully.",
          data: channel
        })

      {:error, :forbidden} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          message: "You cannot update a channel if you are not the owner."
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          message: "Invalid data.",
          errors: Errors.mapper(changeset)
        })
    end
  end

  def delete(%{assigns: assigns} = conn, %{"id" => id}) do
    case Channels.delete_channel(id, assigns.user.id) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{
          message: "Channel deleted successfully."
        })

      {:error, :forbidden} ->
        conn
        |> put_status(:forbidden)
        |> json(%{
          message: "You cannot delete a channel if you are not the owner."
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          message: "Invalid data.",
          errors: Errors.mapper(changeset)
        })
    end
  end

  defp maybe_put_upload_key(attrs, params, upload_field, key_field) do
    case Map.get(params, upload_field) do
      nil ->
        attrs

      upload ->
        filename =
          upload
          |> fetch_upload_filename()
          |> FileHelper.unique_filename()

        Map.put(attrs, key_field, filename)
    end
  end

  defp fetch_upload_filename(%Plug.Upload{} = upload), do: upload.filename
  defp fetch_upload_filename(_), do: nil
end
