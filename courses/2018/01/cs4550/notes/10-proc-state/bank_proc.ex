defmodule BankProc do
  ## Interface

  def start do
    spawn(BankProc, :init, [])
  end

  def start_link() do
    pid = spawn_link(__MODULE__, :init, [])
    Process.register(pid, __MODULE__)
    {:ok, pid}
  end

  def deposit(pid, name, amt) do
    send(pid, {:deposit, name, amt, self()})
    receive do
      {:ok, :deposit} -> :ok
    end
  end

  def get_bal(name, amt) do
    send(__MODULE__, {:get_bal, name, self()})
    receive do
      {:balance, _name, val} -> val
    end
  end

  ## Implementation

  def init do
    state = %{}
    loop(state)
  end

  def add_bal(state, name, bal_adj) do
    new_bal = (state[name] || 0) + bal_adj
    Map.put(state, name, new_bal)
  end

  def loop(state) do
    receive do
      {:get_bal, name, pid} ->
        bal = state[name] || 0
        send(pid, {:balance, name, bal})
        state
      {:deposit, name, amt} ->
        add_bal(state, name, amt)
      {:withdraw, name, amt} ->
        add_bal(state, name, -amt)
      {:transfer, name1, name2, amt} ->
        b1 = state[name1] || 0
        if b1 >= amt do
          state
          |> add_bal(name1, -amt)
          |> add_bal(name2, +amt)
        else
          raise "#{name1} is too broke"
        end
      bad ->
        IO.inspect({:huh?, bad})
        state
    end
  end
end

