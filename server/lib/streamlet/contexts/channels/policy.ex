defmodule Streamlet.Contexts.Channels.Policy do
  @behaviour Bodyguard.Policy

  alias Streamlet.Schemas.{Channel,User}

  def authorize(:create, _, _), do: true

  def authorize(action, %User{id: user_id}, %Channel{user_id: user_id}) when action in [:update, :delete] do
    true
  end

  def authorize(_, _, _), do: false
end
