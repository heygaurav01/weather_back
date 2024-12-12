defmodule WeatherBack.Repo do
  use Ecto.Repo,
    otp_app: :weather_back,
    adapter: Ecto.Adapters.Postgres
end
