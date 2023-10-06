defmodule LyricalWeb.SongsChannel.SongHandlerTest do
  use LyricalWeb.ChannelCase, async: true

  alias LyricalWeb.SongsChannel

  setup do
    socket = socket(LyricalWeb.UserSocket, nil, %{})
    %{socket: socket}
  end

  test "song:{id} replies with song on join", %{socket: socket} do
    song = song_factory()

    {:ok, reply, _} =
      socket
      |> subscribe_and_join(SongsChannel, "song:#{song.id}")
      |> assert_valid_payload()

    assert reply == %SongsChannel.Song{
             id: song.id,
             title: song.title,
             album: song.album,
             artist: song.artist,
             year: song.year,
             artwork_url: song.artwork_url
           }
  end

  describe "stanza:get" do
    test "replies with the specified stanza", %{socket: socket} do
      stanzas = [%{ordinal: 1, lines: ["Line 1"]}, %{ordinal: 2, lines: ["Line 2"]}]
      song = song_factory(stanzas: stanzas)

      {:ok, _, socket} =
        socket
        |> subscribe_and_join(SongsChannel, "song:#{song.id}")
        |> assert_valid_payload()

      ref = push(socket, "stanza:get", %{"ordinal" => 2})

      assert_reply ref, :ok, %SongsChannel.Stanza{ordinal: 2, lines: ["Line 2"]}
    end

    test "replies with error if no stanza exists", %{socket: socket} do
      song = song_factory()

      {:ok, _, socket} =
        socket
        |> subscribe_and_join(SongsChannel, "song:#{song.id}")
        |> assert_valid_payload()

      ref = push(socket, "stanza:get", %{"ordinal" => 1})

      assert_reply ref, :error, :no_stanza
    end
  end

  describe "stanza:next" do
    test "replies with the next stanza", %{socket: socket} do
      stanzas = [%{ordinal: 1, lines: ["Line 1"]}, %{ordinal: 2, lines: ["Line 2"]}]
      song = song_factory(stanzas: stanzas)

      {:ok, _, socket} =
        socket
        |> subscribe_and_join(SongsChannel, "song:#{song.id}")
        |> assert_valid_payload()

      push(socket, "stanza:get", %{"ordinal" => 1})

      ref = push(socket, "stanza:next", %{})

      assert_reply ref, :ok, %SongsChannel.Stanza{ordinal: 2, lines: ["Line 2"]}
    end

    test "replies with the first stanza if there is no ordinal", %{socket: socket} do
      stanzas = [%{ordinal: 1, lines: ["Line 1"]}, %{ordinal: 2, lines: ["Line 2"]}]
      song = song_factory(stanzas: stanzas)

      {:ok, _, socket} =
        socket
        |> subscribe_and_join(SongsChannel, "song:#{song.id}")
        |> assert_valid_payload()

      ref = push(socket, "stanza:next", %{})

      assert_reply ref, :ok, %SongsChannel.Stanza{ordinal: 1, lines: ["Line 1"]}
    end

    test "replies with error if no stanza exists", %{socket: socket} do
      song = song_factory()

      {:ok, _, socket} =
        socket
        |> subscribe_and_join(SongsChannel, "song:#{song.id}")
        |> assert_valid_payload()

      ref = push(socket, "stanza:next", %{"ordinal" => 1})

      assert_reply ref, :error, :no_stanza
    end
  end

  describe "stanza:prev" do
    test "gets the previous stanza when one is available", %{socket: socket} do
      stanzas = [%{ordinal: 1, lines: ["Line 1"]}, %{ordinal: 2, lines: ["Line 2"]}]
      song = song_factory(stanzas: stanzas)

      {:ok, _, socket} =
        socket
        |> subscribe_and_join(SongsChannel, "song:#{song.id}")
        |> assert_valid_payload()

      push(socket, "stanza:get", %{"ordinal" => 2})

      ref = push(socket, "stanza:prev", %{})

      assert_reply ref, :ok, %SongsChannel.Stanza{ordinal: 1, lines: ["Line 1"]}
    end

    test "replies with error if no stanza exists", %{socket: socket} do
      song = song_factory()

      {:ok, _, socket} =
        socket
        |> subscribe_and_join(SongsChannel, "song:#{song.id}")
        |> assert_valid_payload()

      ref = push(socket, "stanza:prev", %{"ordinal" => 1})

      assert_reply ref, :error, :no_stanza
    end
  end
end
