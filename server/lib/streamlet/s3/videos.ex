defmodule Streamlet.S3.Videos do
  alias ExAws.S3
  alias Streamlet.S3.Constants

  def all() do
    Constants.videos_bucket
    |> S3.list_objects
    |> ExAws.stream!
    |> Enum.to_list
  end

  def create(file_path, user_id, filename) do
    file_path
    |> S3.Upload.stream_file
    |> S3.upload(Constants.videos_bucket(), upload_path(user_id, filename))
    |> ExAws.request
  end

  defp upload_path(user_id, filename) do
    "#{user_id}/#{filename}"
  end
end
