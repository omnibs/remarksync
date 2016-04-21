defmodule Remarksync.Registry do
  use GenServer

  def start_link do
    GenServer.start_link __MODULE__, :ok, name: __MODULE__
  end

  def lookup(table_name, %{id: id}) when is_atom(table_name) do
    case :ets.lookup(table_name, id) do
      [{^id, state}] -> {:ok, state}
      [] -> :error
    end
  end

  def create(state), do: GenServer.call(__MODULE__, {:create, state})

  def update(state), do: GenServer.call(__MODULE__, {:update, state})

  @doc """
  Stops the registry.
  """
  def stop do
    GenServer.stop(__MODULE__)
  end

  ## Server callbacks

  def init(:ok) do
    slots = :ets.new(:slots, [:named_table, read_concurrency: true])
    {:ok, slots}
  end

  def handle_call({:create, state}, _from, slots) do
    # 5. Read and write to the ETS table instead of the map
    case lookup(slots, state) do
      {:ok, cur_state} ->
        {:reply, cur_state, slots}
      :error ->
        :ets.insert(slots, {state.id, state})
        {:reply, state, slots}
    end
  end

  def handle_call({:update, state}, _from, slots) do
    case lookup(slots, state) do
      {:ok, _} ->
        :ets.insert(slots, {state.id, state})
        {:reply, {:ok, state}, slots}
      :error ->
        {:reply, {:error, :notfound}, slots}
    end
  end
end