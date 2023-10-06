defmodule LyricalWeb.SongsChannel.Song do
  @moduledoc """
  A representation of a `Lyrical.Songs.Song` suitable for network
  transmission.
  """

  use LyricalWeb.ChannelSchema

  @fields ~w(id title album artist year artwork_url)a

  embedded_schema do
    field(:id, :integer)
    field(:title, :string)
    field(:album, :string)
    field(:artist, :string)
    field(:year, :integer)
    field(:artwork_url, :string)

    embeds_many(:stanzas, LyricalWeb.SongsChannel.Stanza)
  end

  @impl true
  def build_params(%Lyrical.Songs.Song{} = song) do
    song
    |> Map.from_struct()
    |> Map.take(@fields)
  end

  @impl true
  def changeset(%__MODULE__{} = song, params) do
    song
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
