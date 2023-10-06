defmodule Lyrical.Factories do
  alias Lyrical.Songs

  def song_factory(params \\ []) do
    {:ok, song} =
      params
      |> Enum.into(%{})
      |> Map.put_new(:title, "Tallahassee")
      |> Map.put_new(:album, "Tallahassee")
      |> Map.put_new(:artist, "The Mountain Goats")
      |> Map.put_new(:year, 2002)
      |> Map.put_new(:artwork_url, "https://album.art/123")
      |> Songs.create_song()

    song
  end
end
