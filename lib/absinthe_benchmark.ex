defmodule AbsintheBenchmark do
  @moduledoc """
  Documentation for AbsintheBenchmark.
  """

  @root_value %{
    users: [
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
    ]
  }

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

  def benchmark do
    Absinthe.run(@query_document, AbsintheBenchmark.Schema, root_value: @root_value)
  end
  def relay_benchmark do
    Absinthe.run(@query_document, AbsintheBenchmark.RelaySchema, root_value: @root_value)
  end
end
