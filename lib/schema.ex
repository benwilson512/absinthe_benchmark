defmodule AbsintheBenchmark.Schema do
  use Absinthe.Schema

  def timing(res, _) do
    res
  end

  # def middleware(middleware, field, object) do
  #   middleware =
  #     middleware
  #     |> Absinthe.Schema.ensure_middleware(field, object)
  #   [{{__MODULE__, :timing}, :start}] ++ middleware ++ [{{__MODULE__, :timing}, :stop}]
  # end

  object :user do
    field :a0, :integer
    field :a1, :integer
    field :a2, :integer
    field :a3, :integer
    field :a4, :integer
    field :a5, :integer
    field :a6, :integer
    field :a7, :integer
    field :a8, :integer
    field :a9, :integer
  end

  object :dog do
    field :name, :string
  end

  union :things do
    types [:user, :dog]
    resolve_type fn
      %{a0: _}, _ -> :user
      _, _ -> :dog
    end
  end

  query do
    field :users, list_of(:things) do
      resolve fn _, %{root_value: users} ->
        {:ok, users}
      end
    end
  end
end
