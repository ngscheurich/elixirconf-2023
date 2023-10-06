defmodule LyricalWeb.SongsChannel do
  @moduledoc """
  Dispatcher for messages sent to the songs channel.
  """

  use LyricalWeb, :channel

  alias __MODULE__.{SongHandler, SongsHandler}

  join "songs", SongsHandler
  join "song:" <> _id, SongHandler

  event "stanza:get", SongHandler
  event "stanza:next", SongHandler
  event "stanza:prev", SongHandler
  event "stanza:like", SongHandler
end
