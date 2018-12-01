defmodule Eerf.Repo do
  use Ecto.Repo,
    otp_app: :eerf,
    adapter: Ecto.Adapters.Postgres
end
