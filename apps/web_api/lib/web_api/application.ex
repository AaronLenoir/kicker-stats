defmodule WebApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: WebApi.PubSub},
      # Start a worker by calling: WebApi.Worker.start_link(arg)
      # {WebApi.Worker, arg}
      {ConCache, [name: :cache, ttl_check_interval: false]},
      {GameStats.Data.Updater,
       %{get: &GameStats.Data.Download.get_stream/0, interval: 60000, cache_name: :cache}}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: WebApi.Supervisor)
  end
end
