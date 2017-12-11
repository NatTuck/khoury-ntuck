defmodule OtpDemo.Stack3 do
  # Based on Registry docs.
  use Agent

  def setup do
    # Registry for our agents.
    {:ok, _} = Registry.start_link(keys: :unique, name: OtpDemo.Stack3.Registry)

    # Supervisor for stack agents.
    {:ok, _} = Supervisor.start_link(
      [child_spec()],
      name: OtpDemo.Stack3.Sup,
      strategy: :simple_one_for_one,
    )
  end

  def child_spec(spec \\ %{}) do
    defaults = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      restart: :permanent,
      shutdown: 5000,
      type: :worker
    }
    Supervisor.child_spec(defaults, spec)
  end

  def start_link(id) do
    Agent.start_link(fn -> [] end, name: reg(id))
  end

  def reg(id) do
    {:via, Registry, {OtpDemo.Stack3.Registry, id}}
  end

  def start(id) do
    Supervisor.start_child(OtpDemo.Stack3.Sup, [id])
  end

  def push(id, vv) do
    Agent.update(reg(id), &([vv | &1]))
  end

  def pop(id) do
    Agent.get_and_update reg(id), fn state ->
      {hd(state), tl(state)}
    end
  end

  def dump(id) do
    Agent.get(reg(id), &(&1))
  end
end
