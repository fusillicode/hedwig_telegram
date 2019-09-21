defmodule Hedwig.Adapters.Telegram do
  use Hedwig.Adapter


  @api_endpoint "https://api.telegram.org"

  defmodule State do
    defstruct conn: nil,
              conn_ref: nil,
              groups: %{},
              id: nil,
              name: nil,
              opts: nil,
              robot: nil,
              token: nil,
              users: %{}
  end

  def init({robot, opts}) do
    {token, opts} = Keyword.pop(opts, :token)
    {:ok, %State{opts: opts, robot: robot, token: token}}
  end

  def handle_cast({:get_me, _msg}, %{conn: _conn} = state) do
    Tesla.get("#{@api_endpoint}/#{@token}/getMe")
    {:noreply, state}
  end

  def handle_info(:start_poll, %{token: _token} = _state) do
    HedwigTelegram.Connection.start(polling_endpoint())
  end

  defp polling_endpoint, do: "#{@api_endpoint}/#{@token}/getUpdates"
end
