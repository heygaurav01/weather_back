defmodule WeatherBackWeb.WeatherController do
  use WeatherBackWeb, :controller
  alias WeatherBack.Weather

  def index(conn, %{"city" => city}) do
    case Weather.fetch_weather(city) do
      {:ok, weather_data} ->
        json(conn, weather_data)

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Failed to fetch weather", reason: inspect(reason)})
    end
  end
end
