defmodule LyricalWeb.SongsChannel.Stanza do
  @moduledoc """
  A representation of a `Lyrical.Songs.Stanza` suitable for network
  transmission.
  """

  use LyricalWeb.ChannelSchema

  @fields ~w(ordinal lines)a

  embedded_schema do
    field(:ordinal, :integer)
    field(:lines, {:array, :string})
  end

  @impl true
  def build_params(%Lyrical.Songs.Stanza{} = stanza) do
    stanza
    |> Map.from_struct()
    |> Map.take(@fields)
  end

  @impl true
  def changeset(%__MODULE__{} = stanza, params) do
    stanza
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
