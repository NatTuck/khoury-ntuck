defmodule OtpDemo.Stack2 do
  # Based on Registry docs.
  use Agent

  def start_registry do
    Registry.start_link(keys: :unique, name: OtpDemo.Stack2.Registry)
  end

  def reg(id) do
    {:via, Registry, {OtpDemo.Stack2.Registry, id}}
  end

  def start_link(id) do
    Agent.start_link(fn -> [] end, name: reg(id))
  end

  def push(id, vv) do
    Agent.update(reg(id), &([vv | &1]))
  end

  def pop(id) do
    Agent.get_and_update reg(id), fn state ->
      {hd(state), tl(state)}
    end
  end
end
