defmodule AbsintheBenchmark.RelaySchema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema

  node object :user do
    field :name, :string
    field :address, :string
    field :email, :string
    field :password, :string
    field :shoe_size, :integer
    field :friends, type: list_of(:user) do
      resolve fn (%{}, %{source: user, root_value: root_value}) -> 
        friends = Map.values(Map.take(root_value, user.friend_ids))
        {:ok, friends}
      end
    end
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
        %{type: :user, id: id}, %{root_value: users} ->
          user = Map.get(users, id)
          {:ok, user}
        _, _ ->
          {:ok, nil}
      end
    end
  end
end
