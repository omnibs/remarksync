defmodule Remarksync.SlideshowChannelTest do
  use Remarksync.ChannelCase

  alias Remarksync.SlideshowChannel

  setup do
    Remarksync.Registry.start_link

    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(SlideshowChannel, "slideshow:lobby")

    {:ok, socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to slideshow:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end

  test "new slideshow returns same state" do
    {:ok, result, _socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(SlideshowChannel, "slideshow:1", %{"state" => "1"})

    assert result == %{state: "1"}
  end

  test "existing slideshow returns existing state" do
    {:ok, _, _socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(SlideshowChannel, "slideshow:1", %{"state" => "2"})

    {:ok, result, _socket} =
      socket("user_id", %{some: :other})
      |> subscribe_and_join(SlideshowChannel, "slideshow:1", %{"state" => "1"})

    assert result == %{state: "2"}
  end

  # test "existing slideshow returns existing state" do
  #   {:ok, result1, _socket} =
  #     socket("user_id", %{some: :assign})
  #     |> subscribe_and_join(SlideshowChannel, "slideshow:1", %{"state" => "1"})

  #   {:ok, result2, _socket} =
  #     socket("user_id", %{some: :wat})
  #     |> subscribe_and_join(SlideshowChannel, "slideshow:1", %{"state" => "123"})

  #   assert result2 == %{state: "1"}
  # end
end
