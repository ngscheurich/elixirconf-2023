defmodule LyricalWeb.Channels.Dispatcher do
  @moduledoc ~S"""
  Macros that form a simple DSL for dispatching Phoenix Channels
  messages. These macros are meant to provide:

    * An expressive, easy-to-scan syntax for enumerating the callbacks
      that your Channel supports
    * A mechanism for organizing your handler functions among multiple
      modules

  ## Usage

  To get access to the dispatch macros, `use` this module in your
  Channel module:

  ```elixir
  defmodule LyricalWeb.Channels.MyChannel
    use LyricalWeb.Channels.Dispatcher 
    
    ...
  end
  ```

  `Dispatcher` provides macros that allow you to generate the three
  most common Channels callbacks:

    * `join`, for `c:join/3`
    * `event`, for `c:handle_in/3`
    * `info`, for `c:handle_info/2`

  ### join

  Use the `join` macro to generate `c:join/3` callbacks. It has two
  forms. The first dispatches to a specified module and function:

  ```elixir
  join "room:" <> _room_id, RoomHandler, :join
  ```

  In the above example, the `RoomHandler` module should define a
  `join/3` function that accepts the same arguments as `c:join/3`.

  If a function is not specified, `join` will dispatch to `join/3` in
  the given module. For example, the following will call
  `RoomHandler.join/3`:

  ```elixir
  join "room:" <> _room_id, RoomHandler
  ```

  The second form of `join` uses an anonymous function to define the
  callback logic. It accepts the same arguments as `c:join/3`.

  ```elixir
  join "room:" <> _, fn "room:" <> _room_id, _payload, socket ->
    room = Rooms.get_room!(room_id)
    {:ok, assign(socket, :room, room)}
  end
  ```

  ### event

  Use the `event` macro to generate `c:handle_in/3` callbacks. It has
  two forms. The first dispatches the function to another module:

  ```elixir
  event "message:new", RoomHandler, :new_message
  ```

  In the above example, the `RoomHandler` module should define a
  `new_message/3` function that accepts the same arguments as
  `c:handle_in/3`.

  If a function is not specified, `event` will dispatch to
  `handle_in/3` in the given module. For example, the following will
  call `RoomHandler.handle_in/3`:
  ```elixir
  event "message:new", RoomHandler
  ```

  The second form of `event` uses an anonymous function to define the
  callback logic. It accepts the same arguments as `c:handle_in/3`.

  ```elixir
  event "message:new", fn _event, %{"text" => text}, socket ->
    :ok = PubSub.broadcast!("messages:" <> socket.assigns.room_id, text)
    {:reply, {:ok, {:binary, "Message posted"}}, socket}
  end
  ```

  ### info

  Use the `info` macro to generate `c:handle_info/2` callbacks. It has
  two forms. The first dispatches the callback to another module:

  ```elixir
  info {"user:entered", _user}, RoomHandler, :user_entered
  ```

  In the above example, the `RoomHandler` module should define a
  `user_entered/3` function that accepts the same arguments as
  `c:handle_info/2`.

  If a function is not specified, `info` will dispatch to
  `handle_info/2` in the given module. For example, the following will
  call `RoomHandler.handle_info/2`:

  ```elixir
  info {"user:entered", _user}, RoomHandler
  ```

  The second form of `event` uses an anonymous function to define the
  callback logic. It accepts the same arguments as `c:handle_info/2`.

  ```elixir
  info {"user:entered", _}, fn {_, %{"name" => name}}, socket ->
    :ok = PubSub.broadcast!("events:" <> socket.assigns.room_id, "#{name} is here!")
    {:noreply, socket}
  end
  ```
  """

  defmacro __using__(_opts) do
    quote do
      import LyricalWeb.Channels.Dispatcher
    end
  end

  defmacro join(topic, {:__aliases__, _, _} = mod) do
    __join__(topic, mod, :join)
  end

  defmacro join(topic, {:__aliases__, _, _} = mod, fun) do
    __join__(topic, mod, fun)
  end

  defmacro join(topic, {:fn, _, _} = fun) do
    quote do
      def join(unquote(topic) = topic, payload, socket) do
        unquote(fun).(topic, payload, socket)
      end
    end
  end

  defmacro event(event, {:__aliases__, _, _} = mod) do
    __event__(event, mod, :handle_in)
  end

  defmacro event(event, {:__aliases__, _, _} = mod, fun) do
    __event__(event, mod, fun)
  end

  defmacro event(event, {:fn, _, _} = fun) do
    quote do
      def handle_in(unquote(event) = event, payload, socket) do
        unquote(fun).(event, payload, socket)
      end
    end
  end

  defmacro info(msg, {:__aliases__, _, _} = mod) do
    __info__(msg, mod, :handle_info)
  end

  defmacro info(msg, {:__aliases__, _, _} = mod, fun) do
    __info__(msg, mod, fun)
  end

  defmacro info(msg, {:fn, _, _} = fun) do
    quote do
      def handle_info(unquote(msg) = msg, socket) do
        unquote(fun).(msg, socket)
      end
    end
  end

  defp __join__(topic, mod, fun) do
    quote do
      def join(unquote(topic) = topic, payload, socket) do
        apply(unquote(mod), unquote(fun), [topic, payload, socket])
      end
    end
  end

  defp __event__(event, mod, fun) do
    quote do
      def handle_in(unquote(event) = event, payload, socket) do
        apply(unquote(mod), unquote(fun), [event, payload, socket])
      end
    end
  end

  defp __info__(msg, mod, fun) do
    quote do
      def handle_info(unquote(msg) = msg, socket) do
        apply(unquote(mod), unquote(fun), [msg, socket])
      end
    end
  end
end
