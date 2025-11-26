defmodule Streamlet.Contexts.ImageStorage do
  @moduledoc """
  Handles all image-related storage operations.
  """

  alias ExAws.S3

  @spec upload(source :: String.t(), bucket :: String.t(), path :: String.t()) :: {:ok, term()} | {:error, term()}
  def upload(source, bucket, path) do
    source
    |> S3.Upload.stream_file
    |> S3.upload(bucket, path)
    |> ExAws.request
  end

  @spec delete(bucket :: String.t(), key :: String.t()) :: {:ok, term()} | {:error, term()}
  def delete(bucket, key) do
    bucket
    |> S3.delete_object(key)
    |> ExAws.request
  end
end
