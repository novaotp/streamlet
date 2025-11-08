defmodule Streamlet.Constants do
  def session_token_cookie_name(), do: "streamlet_session_token"
  def session_token_cookie_opts(), do: [same_site: "strict", secure: true, http_only: true]
end
