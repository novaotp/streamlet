defmodule Streamlet.Contexts.ImageStorage do
  @spec upload(source :: String.t(), bucket :: String.t(), path :: String.t()) :: {:ok, term()} | {:error, term()}
  def upload(source, bucket, path) do
    source
    |> S3.Upload.stream_file
    |> S3.upload(bucket, path)
    |> ExAws.request
  end
end
