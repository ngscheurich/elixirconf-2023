defmodule Lyrical.Songs do
  @moduledoc """
  Functions for working with songs.
  """

  import Ecto.Query

  alias Lyrical.Repo
  alias __MODULE__.Song
  alias __MODULE__.Stanza

  @doc """
  Returns the list of `Lyrical.Songs.Song`s.
  """
  @spec list_songs() :: [Song.t()]
  def list_songs do
    Repo.all(Song)
  end

  @doc """
  Creates a new `Lyrical.Songs.Song`.

  Returns the `Song`, or an `Ecto.Changeset` on failure.
  """
  @spec create_song(map()) :: {:ok, Song.t()} | {:error, Ecto.Changeset.t()}
  def create_song(params) do
    %Song{}
    |> Song.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Updates a `Lyrical.Songs.Song`.

  Returns the updated `Song`, or an `Ecto.Changeset` on failure.
  """
  @spec update_song(Song.t(), map()) :: {:ok, Song.t()} | {:error, Ecto.Changeset.t()}
  def update_song(song, params) do
    song
    |> Song.changeset(params)
    |> Repo.update()
  end

  @doc """
  Returns the `Lyrical.Songs.Song` with the given `id`.

  Raise `Ecto.NoResultsError` if no such `Song` exists.
  """
  @spec get_song!(pos_integer()) :: Song.t() 
  def get_song!(id) do
    Repo.get!(Song, id)
  end

  @doc """
  Returns the `Lyrical.Songs.Stanza` at `ordinal` for the
  `Lyrical.Songs.Song` with the given `id`.

  Returns `:error` if no such `Stanza` exists.
  """
  @spec fetch_stanza(pos_integer(), integer()) :: {:ok, Stanza.t()} | :error
  def fetch_stanza(song_id, ordinal) do
    query =
      from(sz in Stanza,
        join: sg in Song,
        on: sg.id == sz.song_id,
        where: sg.id == ^song_id,
        where: sz.ordinal == ^ordinal
      )

    case Repo.one(query) do
      %Stanza{} = stanza -> {:ok, stanza}
      nil -> :error
    end
  end
end
