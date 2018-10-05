defmodule HangmanWeb.UserSocket do
  use Phoenix.Socket
 
  ## Channels
  channel "games:*", HangmanWeb.GamesChannel

  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
      {:ok, user} ->
        IO.puts("socket connect from user = #{user}")
        {:ok, assign(socket, :user, user)}
      {:error, _reason} ->
        :error
    end
  end

  def id(_socket), do: nil
end
