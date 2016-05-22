defmodule Remarksync.SlideshowChannel do
  use Remarksync.Web, :channel

  alias Remarksync.Registry, as: Registry

  def join("slideshow:" <> id, %{"state" => state}, socket) do
    {:ok, get_or_create(id, state), socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (slideshow:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("change", %{"state" => state}, socket) do
    "slideshow:" <> id = socket.topic
    case Registry.update(%{id: id, state: state}) do
      {:ok, new_state} ->
        broadcast socket, "changed", %{state: new_state.state}
        {:noreply, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}}
    end
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  defp get_or_create(id, state) do
    %{state: existing_state} = Registry.create(%{id: id, state: state})
    %{state: existing_state}
  end

end
