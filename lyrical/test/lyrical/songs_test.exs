defmodule Lyrical.SongsTest do
  use Lyrical.DataCase, async: true

  alias Lyrical.Songs
  alias Lyrical.Songs.Song

  test "list_songs/0 returns the list of songs" do
    song = song_factory()
    assert Songs.list_songs == [song]
  end

  describe "create_song/1" do
    test "returns song with valid params" do
      params = %{
        title: "Cubs in Five",
        album: "Nine Black Poppies",
        artist: "The Mountain Goats",
        year: 1995,
        artwork_url: "https://album.art/456"
      }

      assert {:ok,
              %Song{
                title: "Cubs in Five",
                album: "Nine Black Poppies",
                artist: "The Mountain Goats",
                year: 1995,
                artwork_url: "https://album.art/456"
              }} = Songs.create_song(params)
    end

    test "returns changeset with invalid params" do
      assert {:error, %Ecto.Changeset{}} = Songs.create_song(%{})
    end
  end

  describe "update_song/2" do
    test "updates song with valid params" do
      song = song_factory(album: "Nine Black Poppies")
      assert {:ok, %Song{album: "Tallahassee"}} = Songs.update_song(song, %{album: "Tallahassee"})
    end

    test "returns changeset with invalid params" do
      song = song_factory()
      assert {:error, %Ecto.Changeset{}} = Songs.update_song(song, %{album: nil})
    end
  end

  describe "get_song!/1" do
    test "returns song with matching id" do
      %{id: song_id} = song_factory()
      assert %Song{id: ^song_id} = Songs.get_song!(song_id)
    end

    test "raises if song with id doesn't exist" do
      assert_raise Ecto.NoResultsError, fn -> Songs.get_song!(1) end
    end
  end

  describe "fetch_stanza" do
    test "returns stanza with matching ordinal" do
      stanzas = [
        %{
          ordinal: 1,
          lines: [
            "Window facing an ill-kept front yard",
            "Plums on the tree heavy with nectar",
            "Prayers to summon the destroying angel",
            "Moon stuttering in the sky like film stuck in a projector",
            "And you",
            "You"
          ]
        },
        %{
          ordinal: 2,
          lines: [
            "Twin prop airplanes passing loudly overhead",
            "Road to the airport two lanes clear",
            "Half the whole town gone for the summer",
            "Terrible silence coming down here",
            "And you",
            "You"
          ]
        }
      ]

      song = song_factory(stanzas: stanzas)

      assert {:ok, %Lyrical.Songs.Stanza{
               ordinal: 2,
               lines: [
                 "Twin prop airplanes passing loudly overhead",
                 "Road to the airport two lanes clear",
                 "Half the whole town gone for the summer",
                 "Terrible silence coming down here",
                 "And you",
                 "You"
               ]
             }} = Songs.fetch_stanza(song.id, 2)
    end

    test "returns error if no stanza with ordinal" do
      song = song_factory()
      assert Songs.fetch_stanza(song.id, 1) == :error
    end
  end
end
