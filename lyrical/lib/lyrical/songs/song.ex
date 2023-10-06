defmodule Lyrical.Songs.Song do
  @moduledoc """
  A musical composition.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Lyrical.Songs.Stanza
  
  @fields ~w(title album artist year artwork_url)a

  @type t() :: %__MODULE__{}

  schema "songs" do
    field :title, :string
    field :album, :string
    field :artist, :string
    field :year, :integer
    field :artwork_url, :string

    has_many :stanzas, Stanza
  end

  @doc false
  def changeset(song = %__MODULE__{}, params) do
    song
    |> cast(params, @fields)
    |> cast_assoc(:stanzas, with: &Stanza.changeset/2)
    |> validate_required(@fields)
  end
end
