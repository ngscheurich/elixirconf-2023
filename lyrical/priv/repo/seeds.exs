# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Lyrical.Repo.insert!(%Lyrical.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

song = %{
  title: "Title",
  album: "Album",
  artist: "Artist",
  year: 1900,
  artwork_url: "http://localhost:4000/images/album_art.jpg",
  stanzas: [
    %{
      ordinal: 1,
      lines: [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        "Morbi et tincidunt dolor, cursus viverra tellus",
        "Pellentesque in nisl ac urna laoreet condimentum a nec justo"
      ]
    },
    %{
      ordinal: 2,
      lines: [
        "Phasellus at justo mattis, iaculis nisl ac, aliquet purus",
        "Curabitur placerat porttitor malesuada",
        "Suspendisse potenti"
      ]
    },
  ]
}

{:ok, _} = Lyrical.Songs.create_song(song)
