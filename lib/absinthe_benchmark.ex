defmodule AbsintheBenchmark do
  @moduledoc """
  Documentation for AbsintheBenchmark.
  """

  @root_value Map.new([
    %{
      id: 0,
      name: "Adam",
      friend_ids: [1]
    },
    %{
      id: 1,
      name: "Bertha",
      friend_ids: [2, 4]
    },
    %{
      id: 2,
      name: "Charlie",
      friend_ids: [0, 5]
    },
    %{
      id: 3,
      name: "Doris",
      friend_ids: [1, 2]
    },
    %{
      id: 4,
      name: "Eddie",
      friend_ids: [0, 1, 3]
    },
    %{
      id: 5,
      name: "Fiona",
      friend_ids: [0, 2, 4]
    },
    %{
      id: 6,
      name: "Gareth",
      friend_ids: [3, 5]
    }
  ], &{&1.id, &1})

  @query_document """
    query {
      users {
        id
        name
        friends {
          id
          name
          friends {
            id
            name
            friends {
              id
              name
              friends {
                id
                name
                friends {
                  id
                  name
                  friends {
                    id
                    name
                    friends {
                      id
                      name
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    """

  def run do
    Absinthe.run(@query_document, AbsintheBenchmark.Schema, root_value: @root_value)
  end

  def profile do
    alias Absinthe.Phase

    pipeline =
      AbsintheBenchmark.Schema
      |> Absinthe.Pipeline.for_document(root_value: @root_value)
      |> Absinthe.Pipeline.upto(Phase.Document.Complexity.Result)

    {:ok, blueprint, _} = Absinthe.Pipeline.run(@query_document, pipeline)

    inner_pipeline = [
      Phase.Document.Execution.BeforeResolution,
      {Phase.Document.Execution.Resolution, [root_value: @root_value]},
      Phase.Document.Execution.AfterResolution,
    ]

    fun = fn ->
      {:ok, blueprint, _} = Absinthe.Pipeline.run(blueprint, inner_pipeline)
    end

    Mix.Tasks.Profile.Fprof.profile(fun, [])
  end

  def benchmark do
    alias Absinthe.Phase

    pipeline =
      AbsintheBenchmark.Schema
      |> Absinthe.Pipeline.for_document(root_value: @root_value)
      |> Absinthe.Pipeline.upto(Phase.Document.Complexity.Result)

    {:ok, blueprint, _} = Absinthe.Pipeline.run(@query_document, pipeline)

    inner_pipeline = [
      Phase.Document.Execution.BeforeResolution,
      {Phase.Document.Execution.Resolution, [root_value: @root_value]},
      Phase.Document.Execution.AfterResolution,
    ]

    fun = fn ->
      {:ok, blueprint, _} = Absinthe.Pipeline.run(blueprint, inner_pipeline)
    end

    Benchee.run(%{
      "stuff" => fun
    })
  end
end
