defmodule HangmanWeb.PlayerChannel do
  use HangmanWeb, :channel
  alias Hangman.Game
  alias Hangman.GameAgent

  def join("player:" <> name, _payload, socket) do
    if authorized?(socket, name) do
      game = GameAgent.get(name) || Game.new()
      GameAgent.put(name, game)
      socket = socket
      |> assign(:name, name)
      {:ok, Game.client_view(game), socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("guess", %{"letter" => ll}, socket) do
    name = socket.assigns[:name]
    game = name
    |> GameAgent.get()
    |> Game.guess(ll)
    GameAgent.put(name, game)
    {:reply, {:ok, Game.client_view(game)}, socket}
  end

  defp authorized?(socket, name) do
    socket.assigns[:username] == name
  end
end
