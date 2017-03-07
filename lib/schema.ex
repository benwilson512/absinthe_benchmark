defmodule AbsintheBenchmark.Schema do
  use Absinthe.Schema

  object :user do
    field :id, :id
    field :name, :string
    field :friends, type: list_of(:user) do
      resolve fn user, _, %{root_value: all_users} ->
        friends =
          all_users
          |> Map.take(user.friend_ids)
          |> Map.values
        {:ok, friends}
      end
    end
  end

  query do
    field :users, list_of(:user) do
      resolve fn _, %{root_value: all_users} ->
        {:ok, Map.values(all_users)}
      end
    end
  end
end
