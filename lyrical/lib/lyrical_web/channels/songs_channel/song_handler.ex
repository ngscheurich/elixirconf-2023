defmodule LyricalWeb.SongsChannel.SongHandler do
  @moduledoc """
  Dispatch handler.
  """

  @behaviour Phoenix.Channel

  import Phoenix.Socket, only: [assign: 3]
  import Phoenix.Channel, only: [broadcast!: 3]

  alias Lyrical.Songs
  alias LyricalWeb.SongsChannel

  @no_stanza :no_stanza

  @impl true
  def join("song:" <> id, _payload, socket) do
    reply =
      id
      |> String.to_integer()
      |> Songs.get_song!()
      |> SongsChannel.Song.build!()

    socket = assign(socket, :song_id, id)
    {:ok, reply, socket}
  end

  @impl true
  def handle_in("stanza:get", %{"ordinal" => ordinal}, socket) do
    reply_with_stanza(socket, ordinal)
  end

  def handle_in("stanza:next", _payload, %{assigns: %{ordinal: ordinal}} = socket) do
    reply_with_stanza(socket, ordinal + 1)
  end

  def handle_in("stanza:next", _payload, socket) do
    reply_with_stanza(socket, 1)
  end

  def handle_in("stanza:prev", _payload, %{assigns: %{ordinal: ordinal}} = socket) do
    reply_with_stanza(socket, ordinal - 1)
  end

  def handle_in("stanza:prev", _payload, socket) do
    {:reply, {:error, @no_stanza}, socket}
  end

  def handle_in("stanza:like", _payload, socket) do
    broadcast!(socket, "like", %{}) |> dbg()
    {:noreply, socket}
  end

  defp reply_with_stanza(socket, ordinal) do
    case Songs.fetch_stanza(socket.assigns.song_id, ordinal) do
      {:ok, stanza} ->
        stanza = SongsChannel.Stanza.build!(stanza)
        socket = assign(socket, :ordinal, ordinal)
        {:reply, {:ok, stanza}, socket}

      :error ->
        {:reply, {:error, @no_stanza}, socket}
    end
  end
end
