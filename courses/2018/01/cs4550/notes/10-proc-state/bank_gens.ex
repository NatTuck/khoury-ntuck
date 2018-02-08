defmodule BankGens do
  use GenServer

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def deposit(name, amt) do
    GenServer.cast(__MODULE__, {:adjust, name, +amt})
  end

  def withdraw(name, amt) do
    GenServer.cast(__MODULE__, {:adjust, name, -amt})
  end

  def get_bal(name) do
    GenServer.call(__MODULE__, {:get_bal, name})
  end

  def transfer(name1, name2, amt) do
    GenServer.call(__MODULE__, {:transfer, name1, name2, amt})
  end

  # Server (callbacks)

  def handle_call({:get_bal, name}, _from, state) do
    {:reply, state[name], state}
  end

  def handle_call({:transfer, name1, name2, amt}, _from, state) do
    bal1 = state[name1] || 0
    if bal1 >= amt do
      bal2 = state[name2] || 0
      state = state
      |> Map.put(name1, bal1 - amt)
      |> Map.put(name2, bal2 + amt)
      {:reply, :ok, state}
    else
      {:reply, {:error, "Insufficient funds for #{name1}"}, state}
    end
  end

  def handle_call(request, from, state) do
    # Call the default implementation from GenServer
    super(request, from, state)
  end

  def handle_cast({:adjust, name, amt}, state) do
    bal0 = state[name] || 0
    bal1 = bal0 + amt
    {:noreply, Map.put(state, name, bal1) }
  end

  def handle_cast(request, state) do
    super(request, state)
  end
end

