defmodule EerfWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use EerfWeb, :controller
      use EerfWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: EerfWeb

      import Plug.Conn
      import EerfWeb.Gettext
      alias EerfWeb.Router.Helpers, as: Routes

      alias Eerf.Auth.Guardian
      alias Eerf.Auth
      alias Eerf.Auth.User

      alias Eerf.Rooms
      alias Eerf.Rooms.Room

      def check_auth_user(conn) do
        changeset = Auth.change_user(%User{})

        maybe_user = Guardian.Plug.current_resource(conn)

        {changeset, maybe_user}
      end

      def populate_init_user(conn, _) do
        {changeset, maybe_user} = check_auth_user(conn)

        conn
        |> assign(:changeset, changeset)
        |> assign(:maybe_user, maybe_user)
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/eerf_web/templates",
        namespace: EerfWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import EerfWeb.ErrorHelpers
      import EerfWeb.Gettext
      alias EerfWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import EerfWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
