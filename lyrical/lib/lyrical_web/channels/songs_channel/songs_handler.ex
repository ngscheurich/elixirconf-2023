defmodule LyricalWeb.SongsChannel.SongsHandler do
  @moduledoc """
  Dispatch handler.
  """

  @behaviour Phoenix.Channel

  alias Lyrical.Songs
  alias LyricalWeb.SongsChannel

  @impl true
  def join("songs", _payload, socket) do
    songs = Enum.map(Songs.list_songs(), &SongsChannel.Song.build!/1)
    {:ok, %{songs: songs}, socket}
  end
end
