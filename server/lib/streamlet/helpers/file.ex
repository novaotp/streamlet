defmodule Streamlet.Helpers.File do
  @doc """
  Returns a unique filename, using the same extension as the old filename.

  ### Note

  For filenames starting with a dot and without an extension, it returns a unique
  filename with no extension.
  """
  def unique_filename(old_filename) when is_binary(old_filename) do
    filename = UUID.uuid4()
    ext = Path.extname(old_filename)

    filename <> ext
  end
  def unique_filename(_), do: nil
end
