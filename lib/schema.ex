defmodule AbsintheBenchmark.Schema do
  use Absinthe.Schema
  import_types AbsintheBenchmark.Schema.Types

  query do
    field :root_user, :user
    field :users, list_of(:user)
  end
end
