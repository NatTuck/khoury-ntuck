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
    Agent.start_link(fn -> 0 end, name: reg(id))
  end

  def inc(id) do
    Agent.update(reg(id), &(&1 + 1))
  end

  def get(id) do
    Agent.get(reg(id), &(&1))
  end
end
