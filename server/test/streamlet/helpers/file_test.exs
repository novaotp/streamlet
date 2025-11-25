defmodule Streamlet.Helpers.FileTest do
  use ExUnit.Case

  alias Streamlet.Helpers.File, as: FileHelper

  test "unique_filename/1 returns nil if old_filename is not a string" do
    assert FileHelper.unique_filename(1) == nil
    assert FileHelper.unique_filename(:test) == nil
    assert FileHelper.unique_filename(nil) == nil
  end

  test "unique_filename/1 returns a unique name with no extension if old_filename is empty" do
    filename = FileHelper.unique_filename("")

    assert is_binary(filename)
    assert {:ok, _} = UUID.info(filename)
  end

  test "unique_filename/1 returns a unique name with no extension if old_filename is a dot file" do
    filename = FileHelper.unique_filename(".gitignore")

    assert is_binary(filename)
    assert {:ok, _} = UUID.info(filename)
  end

  test "unique_filename/1 returns a unique name with an extension if old_filename contains an extension" do
    expected_extension = "mp4"
    old_filename = "video." <> expected_extension

    unique_filename = FileHelper.unique_filename(old_filename)
    assert is_binary(unique_filename)

    [filename, extension] = String.split(unique_filename, ".")
    assert {:ok, _} = UUID.info(filename)
    assert ^expected_extension = extension
  end
end
