defmodule CounterWeb.Router do
  use CounterWeb, :router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CounterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :basic_auth, username: "admin", password: System.get_env("BASIC_AUTH_PASSWORD") || "password"
  end

  scope "/", CounterWeb do
    pipe_through :browser

    live "/", CounterLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", CounterWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:counter, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:browser, :auth]

      live_dashboard "/dashboard", metrics: CounterWeb.Telemetry

      live "/debug", CounterWeb.DebugLive
    end
  end
end
