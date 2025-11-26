defmodule StreamletWeb.ChannelController do
  use StreamletWeb, :controller

  alias Streamlet.Contexts.{Channels,ImageStorage}
  alias Streamlet.S3.Constants

  def action(conn, _params) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.user])
  end

  def index(conn, _params, _user) do
    conn
    |> put_status(:ok)
    |> json(%{
      data: Channels.list_all()
    })
  end

  def show(conn, %{"id" => id}, _user) do
    with {:ok, channel} <- Channels.get_channel(id) do
      conn
      |> put_status(:ok)
      |> json(%{
        data: channel
      })
    end
  end

  def create(conn, params, user) do
    attrs = Map.put(params, "user_id", user.id)

    with {:ok, channel} <- Channels.create_channel(attrs) do
      conn
      |> put_status(:created)
      |> json(%{
        message: "Channel created successfully.",
        data: channel
      })
    end
  end

  def update(conn, %{"id" => id}, user) do
    with {:ok, channel} <- Channels.get_channel(id),
         :ok <- authorize_update(channel, user),
         {:ok, updated_channel} <- Channels.update_channel(channel, conn.body_params) do
      conn
      |> put_status(:ok)
      |> json(%{
        message: "Channel updated successfully.",
        data: updated_channel
      })
    end
  end

  def update_avatar(conn, %{"avatar" => %Plug.Upload{} = avatar, "id" => id}, user) do
    with {:ok, channel} <- Channels.get_channel(id),
         :ok <- authorize_update(channel, user),
         avatar_key <- build_avatar_key(user.id, avatar.filename),
         {:ok, _} <- ImageStorage.upload(avatar.path, Constants.channel_avatars_bucket(), avatar_key),
         {:ok, channel} <- Channels.update_channel_avatar(channel, avatar_key) do
      conn
      |> put_status(:ok)
      |> json(%{
          message: "Updated channel avatar successfully.",
          data: channel
        })
    end
  end

  def update_avatar(conn, _params, _user) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{
        message: "Expected an avatar."
      })
  end

  def delete(conn, %{"id" => id}, user) do
    with {:ok, channel} <- Channels.get_channel(id),
         :ok <- authorize_delete(channel, user),
         {:ok, _} <- Channels.delete_channel(channel) do
      conn
      |> put_status(:ok)
      |> json(%{
        message: "Channel deleted successfully."
      })
    end
  end

  def delete_avatar(conn, %{"id" => id}, user) do
    with {:ok, channel} <- Channels.get_channel(id),
         :ok <- authorize_delete(channel, user),
         {:ok, _} <- ImageStorage.delete(Constants.channel_avatars_bucket(), channel.avatar_key),
         {:ok, channel} <- Channels.update_channel_avatar(channel, nil) do
      conn
      |> put_status(:ok)
      |> json(%{
          message: "Deleted channel avatar successfully.",
          data: channel
        })
    end
  end

  defp authorize_update(channel, user) do
    Bodyguard.permit(Channels, :update, user, channel)
  end

  defp authorize_delete(channel, user) do
    Bodyguard.permit(Channels, :delete, user, channel)
  end

  defp build_avatar_key(user_id, filename) do
    ext = Path.extname(filename)
    uuid = UUID.uuid4()

    "#{user_id}/#{uuid}#{ext}"
  end
end
