defmodule Hangman.GameAgent do
  # TODO: Build a GenServer-style Agent
  # and a supervisor for them.

  # This can just get stuck in application.ex in Workers

  def start_link() do
    state0 = %{}
    pid = spawn_link(__MODULE__, :run, [state0])
    Process.register(pid, __MODULE__)
    {:ok, pid}
  end

  def get(key) do
    send __MODULE__, {:get, key, self()}
    receive do
      {:ok, :get, val} -> val
    end
  end

  def put(key, val) do
    send __MODULE__, {:put, key, val, self()}
    receive do
      {:ok, :put} -> :ok
    end
  end

  def run(state) do
    receive do
      :exit ->
        Process.exit(self(), :normal)
      {:get, key, pid} ->
        send pid, {:ok, :get, Map.get(state, key)}
        run(state)
      {:put, key, val, pid} ->
        send pid, {:ok, :put}
        run(Map.put(state, key, val))
      _ ->
        Process.exit(self(), :unknown_tag)
    end
  end

  # GameAgent.get(game_name)
  # GameAgent.put(game_name, game_state)

  # :observer.start()
  #
  # Processes:
  #  - Hangman.GameAgent
  #  - PubSub Supervisor
end
