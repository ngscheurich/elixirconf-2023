defmodule LyricalWeb.ChannelSchema do
  @moduledoc """
  Provides a macro for creating representations of core schemas
  suitable for network transmission.
  """

  require Logger

  @callback build_params(struct()) :: map()
  @callback changeset(struct(), map()) :: Ecto.Changeset.t()

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)

      use Ecto.Schema
      import Ecto.Changeset

      @primary_key false
      @derive Jason.Encoder

      @type t() :: %__MODULE__{}

      def build!(data) do
        params = build_params(data)

        __MODULE__
        |> apply(:changeset, [struct(__MODULE__), params])
        |> Ecto.Changeset.apply_action(:validate)
        |> case do
          {:ok, struct} ->
            struct

          {:error, changeset} ->
            raise "invalid schema: " <> inspect(changeset.errors)
        end
      end
    end
  end
end
