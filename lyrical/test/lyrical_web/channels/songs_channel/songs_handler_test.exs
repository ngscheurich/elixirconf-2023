defmodule LyricalWeb.SongsHandlerTest do
  use LyricalWeb.ChannelCase, async: true

  alias LyricalWeb.SongsChannel

  setup do
    socket = socket(LyricalWeb.UserSocket, nil, %{})
    %{socket: socket}
  end

  test "songs replies with list of songs on join", %{socket: socket} do
    song = song_factory()

    {:ok, reply, _} =
      socket
      |> subscribe_and_join(SongsChannel, "songs")
      |> assert_valid_payload()

    assert reply == %{
             songs: [
               %SongsChannel.Song{
                 id: song.id,
                 title: song.title,
                 album: song.album,
                 artist: song.artist,
                 year: song.year,
                 artwork_url: song.artwork_url
               }
             ]
           }
  end
end
