defmodule AbsintheBenchmark.RelaySchema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema
  import_types AbsintheBenchmark.RelaySchema.Types

  node interface do

  end

  query do
    field :root_user, :user
    field :users, list_of(:user)
  end
end
