defmodule Remarksync.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    Remarksync.Registry.start_link
    {:ok, %{}}
  end

  test "registers new slot" do
    state = %{id: "123", state: "321"}
    assert state == Remarksync.Registry.create(state)
  end

  test "registers existing returns previous state" do
    state = %{id: "123", state: "111"}
    assert state == Remarksync.Registry.create(state)

    assert state == Remarksync.Registry.create(%{state| state: "333"})
  end

  test "updates state" do
    state = %{id: "123", state: "111"}
    assert state == Remarksync.Registry.create(state)

    state = %{state| state: "333"}

    assert {:ok, state} == Remarksync.Registry.update(state)

    assert state == Remarksync.Registry.create(state)
  end

  test "fails to update unexisting slot" do
    assert {:error, :notfound} == Remarksync.Registry.update(%{id: "31232", state: "32123"})
  end
end