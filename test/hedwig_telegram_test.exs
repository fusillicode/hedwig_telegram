defmodule HedwigTelegramTest do
  use ExUnit.Case
  doctest HedwigTelegram

  test "greets the world" do
    assert HedwigTelegram.hello() == :world
  end
end
