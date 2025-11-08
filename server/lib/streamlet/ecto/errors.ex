defmodule Streamlet.Ecto.Errors do
  @moduledoc """
  See https://elixirforum.com/t/collecting-and-formatting-changeset-errors/20191/5
  """

  alias Ecto.Changeset

  def mapper(%Changeset{} = changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, val}, acc ->
        String.replace(acc, "%{#{key}}", format(val))
      end)
    end)
  end

  def mapper(other), do: other

  defp format(val) when is_list(val), do: Enum.join(val, ",")
  defp format(val), do: to_string(val)
end
