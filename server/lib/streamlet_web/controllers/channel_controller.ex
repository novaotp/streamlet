defmodule StreamletWeb.ChannelController do
  use StreamletWeb, :controller

  alias Streamlet.Ecto.Errors
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

  def create(%{body_params: body_params} = conn, _opts) do
    changeset = Channel.changeset(%Channel{}, body_params)

    with true <- changeset.valid?,
         {:ok, channel} <- Channel.create(changeset) do
      conn
      |> put_status(:created)
      |> json(%{
        message: "Channel created successfully.",
        data:
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
end
