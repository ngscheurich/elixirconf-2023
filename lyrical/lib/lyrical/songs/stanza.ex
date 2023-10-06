defmodule Lyrical.Songs.Stanza do
  @moduledoc """
  A block of `Lyrical.Songs.Song` lyrics.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  schema "stanzas" do
    field :ordinal, :integer
    field :lines, {:array, :string}

    belongs_to :song, Lyrical.Songs.Song
  end

  @doc false
  def changeset(stanza = %__MODULE__{}, params) do
    stanza
    |> cast(params, ~w(ordinal lines song_id)a)
    |> validate_required(~w(ordinal lines)a)
    |> assoc_constraint(:song)
    |> unique_constraint(:ordinal)
  end
end
