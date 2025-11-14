defmodule StreamletWeb.Router do
  use StreamletWeb, :router

  pipeline :api do
    plug :accepts, ["json", "multipart"]
  end

  pipeline :auth do
    plug StreamletWeb.Plugs.Auth
  end

  scope "/api", StreamletWeb do
    pipe_through :api

    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
    post "/auth/logout", AuthController, :logout

    scope "/" do
      pipe_through :auth

      # User
      get "/users/me", UserController, :me
    end
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:streamlet, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: StreamletWeb.Telemetry
    end
  end
end
