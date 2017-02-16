defmodule AbsintheBenchmark.RelaySchema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation

  node object :user do
    field :id, :id
    field :name, :string
    field :friends, type: list_of(:user) do
      resolve fn (%{}, %{source: user, root_value: root_value}) -> 
        friends =
          root_value.users
          |> Enum.with_index
          |> AbsintheBenchmark.Schema.Types.get_elements_from_list(user.friend_ids)
        {:ok, friends}
      end
    end
  end
end
