defmodule Mix.Tasks.Distclean do
  use Mix.Task

  @shortdoc "Removes stuff we don't care about"
  def run(_) do
    System.cmd("bash", ["-c", "rm -rf _build deps"])
  end
end
