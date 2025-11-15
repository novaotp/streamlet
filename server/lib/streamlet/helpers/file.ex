defmodule Streamlet.Helpers.File do
  def unique_filename(nil), do: nil
  def unique_filename(old_filename) do
    filename = UUID.uuid4()
    ext = Path.extname(old_filename)

    filename <> ext
  end
end
