defmodule AbsintheBenchmarkTest do
  use ExUnit.Case
  doctest AbsintheBenchmark

  @query_document """
  {
    users {
      ...on User {
        a0
        a1
        a2
        a3
        a4
        a5
        a6
        a7
        a8
        a9
      }
    }
  }
  """

  @user 0..9 |> Map.new(&{:"a#{&1}", &1})

  n = 100
  @users 1..n |> Enum.map(fn _ -> @user end)

  test "timing" do
    # Absinthe.Test.prime(AbsintheBenchmark.Schema)
    parent = self()
    spawn_link(fn ->
      {time, result} = :timer.tc(fn ->
        Absinthe.run(@query_document, AbsintheBenchmark.Schema, root_value: @users)
      end)
      send parent, result
      IO.inspect time
    end)
    assert_receive(x, 5)
  end
end
