defmodule Streamlet.S3.Constants do
  def path(bucket) do
    "#{scheme()}#{bucket}.#{host()}:#{port()}"
  end

  def videos_bucket(), do: "videos-bucket"

  defp scheme() do
    Application.get_env(:ex_aws, :s3)
    |> Keyword.fetch!(:scheme)
  end

  defp host() do
    Application.get_env(:ex_aws, :s3)
    |> Keyword.fetch!(:host)
  end

  defp port() do
    Application.get_env(:ex_aws, :s3)
    |> Keyword.fetch!(:port)
  end
end
