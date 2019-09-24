# Hedwig Telegram Adapter

[![Open Source Saturday](https://img.shields.io/badge/%E2%9D%A4%EF%B8%8F-open%20source%20saturday-F64060.svg)](https://www.meetup.com/it-IT/Open-Source-Saturday-Milano/)


> A Telegram Adapter for [Hedwig](https://github.com/hedwig-im/hedwig)

## Getting started

Let's generate a new Elixir application with a supervision tree:

```
λ mix new alfred --sup
* creating README.md
* creating .gitignore
* creating mix.exs
* creating config
* creating config/config.exs
* creating lib
* creating lib/alfred.ex
* creating test
* creating test/test_helper.exs
* creating test/alfred_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

    cd alfred
    mix test

Run "mix help" for more commands.
```

Change into our new application directory:

```
λ cd alfred
```

Add `hedwig_telegram` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:hedwig_telegram, "~> 0.1.0"}]
end
```

Ensure `hedwig_telegram` is started before your application:

```elixir
def application do
  [applications: [:hedwig_telegram]]
end
```

### Generate our robot

```
λ mix hedwig.gen.robot

Welcome to the Hedwig Robot Generator!

Let's get started.

What would you like to name your bot?: alfred

Available adapters

1. Hedwig.Adapters.Telegram
2. Hedwig.Adapters.Console
3. Hedwig.Adapters.Test

Please select an adapter: 1

* creating lib/alfred
* creating lib/alfred/robot.ex
* updating config/config.exs

Don't forget to add your new robot to your supervision tree
(typically in lib/alfred.ex):

    worker(Alfred.Robot, [])
```

### Supervise our robot

We'll want Alfred to be supervised and started when we start our application.
Let's add it to our supervision tree. Open up `lib/alfred.ex` and add the
following to the `children` list:

```elixir
worker(Alfred.Robot, [])
```

### Configuration

The next thing we need to do is configure our bot. Open up
`config/config.exs` and let's take a look at what was generated for us:

```elixir
use Mix.Config

config :alfred, Alfred.Robot,
  adapter: Hedwig.Adapters.Telegram,
  name: "alfred",
  aka: "/",
  responders: [
    {Hedwig.Responders.Help, []},
    {Hedwig.Responders.Ping, []}
  ]
```

So we have the `adapter`, `name`, `aka`, and `responders` set. The `adapter` is
the module responsible for handling all of the Telegram details like connecting and
sending and receiving messages over the network. The `name` is the name that our
bot will respond to. The `aka` (also known as) field is optional, but it allows
us to address our bot with an alias. By default, this alias is set to `/`.

Finally we have `responders`. Responders are modules that provide functions that
match on the messages that get sent to our bot. We'll discuss this further in
a bit.

We'll need to provide a few more things in order for us to connect to our Telegram
server. We'll need to provide our bot's API key like:

```elixir
use Mix.Config

config :alfred, Alfred.Robot,
  adapter: Hedwig.Adapters.Telegram,
  name: "alfred",
  aka: "/",
  # fill in the appropriate API token for your bot
  token: "some api token",
  responders: [
    {Hedwig.Responders.Help, []},
    {Hedwig.Responders.Ping, []}
  ]
```

Great! We're ready to start our bot. From the root of our application, let's run
the following:

```
λ mix run --no-halt
```

This will start our application along with our bot.

Since we have the `Help` responder installed, we can say `alfred help` and we
should see a list of usage for all of the installed responders.


## Telegram Webhook
Messages are received from Telegram using an HTTP webhook. You can use the included `Hedwig.Adapters.Telegram.Webhook` module or define one yourself
as long as it calls `Hedwig.Adapters.Messenger.handle_in/2` to send the message to the robot.

### Using the included server

To use the included webhook with your robot, update your dependencies by including `plug` and `cowboy`:

```elixir
  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:plug, "~> 1.1"}
    ]
  end
```

Finally, add `Hedwig.Adapters.Telegram.Webhook` to your supervision tree alongside your robot

```elixir
    children = [
      worker(Alfred.Robot, []),
      worker(Hedwig.Adapters.Telegram.Webhook, [])
    ]
```

The parameters are:
* `cowboy_options` - a keyword list of options to pass to cowboy (optional)

### Defining your own webhook

If you are defining your own webhook (for instance in a phoenix app), just make sure to call `Hedwig.Adapters.Telegram.handle_in/2`

```elixir
    def my_messenger_callback(conn, params) do
        case Hedwig.Adapters.Telegram.handle_in(robot_name, params) do
            {:error, reason} ->
                # Handle robot not found
            :ok ->
                # Message sent to robot.
       end
    end
```

## What's next?

Well, that's it for now. Make sure to read the [Hedwig Documentation](http://hexdocs.pm/hedwig) for more
details on writing responders and other exciting things!

## LICENSE

Hedwig Telegram source code is licensed under the [MIT License](https://github.com/fusillicode/hedwig_telegram/blob/master/LICENSE.md).


