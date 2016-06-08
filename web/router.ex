defmodule Pxscratch.Router do
  use Pxscratch.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Pxscratch do
    pipe_through :browser # Use the default browser stack

    get "/", PostController, :index
    get "/home", PageController, :index
    get "/settings", PageController, :settings
    put "/save_setting", PageController, :save_setting
    resources "/users", UserController
    resources "/roles", RoleController
    resources "/posts", PostController
    get "/posts/:page_url", PostController, :show
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Pxscratch do
  #   pipe_through :api
  # end
end
