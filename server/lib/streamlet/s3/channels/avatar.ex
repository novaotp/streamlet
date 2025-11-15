defmodule Streamlet.S3.Channels.Avatar do
  import Streamlet.S3.Constants, only: [channel_avatar_bucket: 0]

  alias ExAws.S3

  def create(file_path, channel_id, filename) do
    file_path
    |> S3.Upload.stream_file
    |> S3.upload(channel_avatar_bucket(), upload_path(channel_id, filename))
    |> ExAws.request
  end

  defp upload_path(channel_id, filename) do
    "#{channel_id}/#{filename}"
  end
end
