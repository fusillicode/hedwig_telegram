defmodule HedwigTelegram.Connection do
  use GenServer

  defstruct next_id: 1, owner: nil, ref: nil

  @polling 1000

  def start(url) do
    {:ok, pid} = Supervisor.start_child(HedwigTelegram.ConnectionSupervisor, [url, self()])
    {:ok, pid, Process.monitor(pid)}
  end

  def init(owner) do
    {:ok, %HedwigTelegram.Connection{owner: owner, ref: Process.monitor(owner)}}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def handle_info(:get_updates, {}) do
    Tesla.get()
  end

  def poll() do
    Process.send_after(self(), :get_updates, @polling)
  end
end
