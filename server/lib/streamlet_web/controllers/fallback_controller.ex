defmodule StreamletWeb.FallbackController do
  use StreamletWeb, :controller

  alias Streamlet.Ecto.Errors

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{
        message: "Invalid data.",
        errors: Errors.mapper(changeset)
      })
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> json(%{
        message: "You are not allowed to do this action."
      })
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{
        message: "Not found."
      })
  end

  def call(conn, {:error, _}) do
    conn
    |> put_status(:internal_server_error)
    |> json(%{
        message: "Internal server error."
      })
  end
end
