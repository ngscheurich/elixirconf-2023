# Conversational Web APIs Demos

Contained herein is the source code that I demoed at my [ElixirConf 2023] talk, “Conversational Web APIs”.

You can [view the talk on YouTube][video] and it is described thusly:

> Phoenix Channels are great! They’re a go-to solution for adding real-time capabilities to our apps. But with a bit of creative thinking, Channels can also provide a full-duplex alternative to web API models like REST and GraphQL. Come and learn how building a stateful, Channels-based web interface can reduce network traffic, eliminate data overhead, and provide a unified mechanism for establishing application connectivity to browsers, mobile apps, and hardware devices.
>
>After a brief introduction to (or perhaps a refresher on) Phoenix Channels, we’ll discover the interesting possibilities they represent and the problems they solve when backing a web API. You’ll learn how GridPoint leveraged Channels to build and deploy a “conversational” web API to support a critical business case, get the inside scoop on the tradeoffs involved, and learn why this model might fit your project well.
>
> Stick around until the end for an introduction to a new Elixir library that can help jump-start your explorations with a Channel-based web API.

## Projects

You might notice, upon cursory inspection, that it seems as though I’ve (perhaps _unceremoniously_), jammed the code for four separate projects into a single Git repository. Well, you’re right. I did that. But there _was_ a small ceremony. Let’s just call it a monorepo.

### Counter

The [`counter`](counter) project is a Phoenix app that powered the audience participation bit of the talk. I know some of you in the audience were just jamming on that button—you know who you are!

To run it, `mix setup` and then `mix phx.server`. You’ll need [Elixir].

### Counter Client

The [`counter-client`](counter-client) project is a Electron app that I used to display the audience count average on screen.

To run it, `npm i` and then `npm start`. You’ll need [Node.js].

### Lyrical

The [`lyrical`](lyrical) project is a simple implementation of the songs app I used as an example.

To run it, `mix setup` and then `mix phx.server`. You’ll need [Elixir] and [PostgreSQL]. Check out the [seeds file] to set up your some songs.


### Lyrical App

The [`lyrical-app`](lyrical-app) project is a React Native app that talks to `lyrical`. I demoed this app in the iPhone simulator at the end of the talk.

To run it, `npm i` and then `npm start`. You’ll need [Node.js] and an iOS or Android dev setup.

## Resources

- [“Routing patterns for manageable Phoenix Channels”][post] by Lucas San Román is the blog post I mentioned
- [ChannelHandler] is the great Channels routing library I mentioned
- The [`LyricalWeb.Channels.Dispatcher`][dispatcher] module defines some example routing macros

## License

This code is licensed under the MIT license.

---

[elixirconf 2023]: https://2023.elixirconf.com/
[video]: https://www.youtube.com/watch?v=ZBG9VXTycpI
[elixir]: https://elixir-lang.org/
[node.js]: https://nodejs.org/en
[postgresql]: https://www.postgresql.org/
[seeds file]: lyrical/priv/repo/seeds.exs
[post]: https://felt.com/blog/pheonix-channel-routing-patterns
[channelhandler]: https://github.com/doorgan/channel_handler
[dispatcher]: lyrical/lib/lyrical_web/channels/dispatcher.ex
