defmodule SupervisorProjectTest do
  use ExUnit.Case
  doctest SupervisorProject

  test "greets the world" do
    assert SupervisorProject.hello() == :world
  end
end
