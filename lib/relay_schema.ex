defmodule AbsintheBenchmark.RelaySchema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema

  node object :user do
    field :name, :string
  end

  node interface do
    resolve_type fn
      _, _ ->
       :user
    end
  end

  query do
    field :user, :user do
      arg :id, :id

      middleware Absinthe.Relay.Node.ParseIDs, id: :user

      resolve fn %{id: id}, %{root_value: users} ->
        {:ok, Map.get(users, id)}
      end
    end

    node field do
      resolve fn
        %{type: node_type, id: id}, %{root_value: users} ->
          user = Map.get(users, id)
          {:ok, user}
        _, _ ->
          {:ok, nil}
      end
    end
  end
end
