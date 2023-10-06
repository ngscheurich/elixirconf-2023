defmodule Lyrical.Repo do
  use Ecto.Repo,
    otp_app: :lyrical,
    adapter: Ecto.Adapters.Postgres
end
