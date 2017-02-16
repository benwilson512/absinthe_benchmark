defmodule AbsintheBenchmark.Schema.Types do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :friends, type: list_of(:user) do
      resolve fn (%{}, %{source: user, root_value: root_value}) -> 
        friends =
          root_value.users
          |> Enum.with_index
          |> get_elements_from_list(user.friend_ids)
        {:ok, friends}
      end
    end
  end

  # Grabs from source_list the elements at [indices]
  def get_elements_from_list(source_list, indices, result \\ [])
  def get_elements_from_list([{element, index} | tail], [index | indices_tail], result) do
    get_elements_from_list(tail, indices_tail, [element | result])
  end
  def get_elements_from_list([], _, result), do: result
  def get_elements_from_list(_, [], result), do: result
  def get_elements_from_list([_element | tail], indices, result) do
    get_elements_from_list(tail, indices, result)
  end
end
