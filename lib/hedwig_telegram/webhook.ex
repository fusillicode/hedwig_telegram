defmodule Hedwig.Adapters.Telegram.Webhook do
  use Plug.Builder
  require Logger

  plug(Plug.Logger)

  def start_link() do
    start_link(port: 4000)
  end

  def start_link(cowboy_options) do
    Plug.Adapters.Cowboy.http(__MODULE__, [], cowboy_options)
  end

  def init(options) do
    options
  end

  def call(%Plug.Conn{request_path: "/get/" <> robot_name, method: "POST"} = conn, _) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    case Hedwig.Adapters.Telegram.handle_in(robot_name, body) do
      {:error, _} ->
        conn
        |> send_resp(404, "Not found")
        |> halt

      :ok ->
        conn
        |> send_resp(200, "ok")
        |> halt
    end
  end

  def call(%Plug.Conn{query_string: query_string, method: "GET"} = conn, _opts) do
    token = query_string |> URI.decode_query() |> Map.get("hub.challenge", nil)

    conn
    |> send_resp(200, token)
    |> halt()
  end

  def call(conn, _opts) do
    conn
    |> send_resp(404, "Not found")
    |> halt()
  end
end
