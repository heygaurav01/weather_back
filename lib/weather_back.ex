defmodule WeatherBack do
  # defmodule SimpleServer do
  use Plug.Router

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Welcome to Weather API!")
  end

  get "/weather/:city" do
    case get_weather(city) do
      {:ok, weather_data} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(weather_data))

      {:error, reason} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: reason}))
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp get_weather(city) do
    api_key = "935e4e9557234fa6815180635241012"
    url = "http://api.weatherapi.com/v1/current.json?key=#{api_key}&q=#{city}&aqi=no"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "City not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "API call failed: #{reason}"}

      _ ->
        {:error, "Unknown error occurred"}
    end
  end
end

# @moduledoc """
# WeatherBack keeps the contexts that define your domain
# and business logic.

# Contexts are also responsible for managing your data, regardless
# if it comes from the database, an external API or others.
# """
# end
