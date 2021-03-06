defmodule AbsinthePlugBenchmark do
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
  ], &{"#{&1.id}", &1})

  def node_request(size) do
    Enum.map(0..size, fn i ->
      %{
        "id" => "#{i}",
        "query" => """
          query Index($id_0:ID!) {
            node(id:$id_0) {
              id,
              __typename,
              ...F0
            }
          }
          fragment F0 on User {
            name,
          }
        """,
        "variables" => %{"id_0" => "VXNlcjow"}
      }
    end)
  end

  def user_request(size) do
    Enum.map(0..size, fn i ->
      %{
        "id" => "#{i}",
        "query" => """
          query User($id_0:ID!) {
            user(id:$id_0) {
              id,
              name,
              __typename
            }
          }
        """,
        "variables" => %{"id_0" => "VXNlcjow"}
      }
    end)
  end

  def user_fragment_request(size) do
    Enum.map(0..size, fn i ->
    %{
        "id" => "#{i}",
        "query" => """
          query User($id_0:ID!) {
            user(id:$id_0) {
              id,
              __typename,
              ...F0
            }
          }
          fragment F0 on User {
            name,
          }
        """,
        "variables" => %{"id_0" => "VXNlcjow"}
      }
    end)
  end

  use Plug.Test

  def run do
    opts = Absinthe.Plug.init(schema: AbsintheBenchmark.RelaySchema)

    for payload <- [node_request(0), user_request(0), user_fragment_request(0)] do
      payload = Poison.encode!(payload)

      conn(:post, "/", payload)
      |> put_req_header("content-type", "application/json")
      |> plug_parser
      |> put_private(:absinthe, %{root_value: @root_value})
      |> Absinthe.Plug.call(opts)
      |> case do
        %{status: 200, resp_body: resp_body} ->
          IO.puts resp_body

        %{status: status, resp_body: resp_body} ->
          IO.inspect(status)
          IO.puts resp_body
      end
    end
  end

  def profile do
    opts = Absinthe.Plug.init(schema: AbsintheBenchmark.RelaySchema)

    size = 100

    user_payload = user_request(size) |> Poison.encode!
    user_conn =
      conn(:post, "/", user_payload)
      |> put_req_header("content-type", "application/json")
      |> plug_parser
      |> put_private(:absinthe, %{root_value: @root_value})

    user_fragment_payload = user_fragment_request(size) |> Poison.encode!
    user_fragment_conn =
      conn(:post, "/", user_fragment_payload)
      |> put_req_header("content-type", "application/json")
      |> plug_parser
      |> put_private(:absinthe, %{root_value: @root_value})

    node_payload = node_request(size) |> Poison.encode!
    node_conn =
      conn(:post, "/", node_payload)
      |> put_req_header("content-type", "application/json")
      |> plug_parser
      |> put_private(:absinthe, %{root_value: @root_value})

    fun = fn ->
      %{status: 200} = Absinthe.Plug.call(user_conn, opts)
    end

    Mix.Tasks.Profile.Fprof.profile(fun, [sort: "own"])
  end

  def benchmark do
    opts = Absinthe.Plug.init(schema: AbsintheBenchmark.RelaySchema)

    size = 100

    user_payload = user_request(size) |> Poison.encode!
    user_conn =
      conn(:post, "/", user_payload)
      |> put_req_header("content-type", "application/json")
      |> plug_parser
      |> put_private(:absinthe, %{root_value: @root_value})

    user_fragment_payload = user_fragment_request(size) |> Poison.encode!
    user_fragment_conn =
      conn(:post, "/", user_fragment_payload)
      |> put_req_header("content-type", "application/json")
      |> plug_parser
      |> put_private(:absinthe, %{root_value: @root_value})

    node_payload = node_request(size) |> Poison.encode!
    node_conn =
      conn(:post, "/", node_payload)
      |> put_req_header("content-type", "application/json")
      |> plug_parser
      |> put_private(:absinthe, %{root_value: @root_value})

    Benchee.run(%{
      "user_request" => fn ->
        %{status: 200} = Absinthe.Plug.call(user_conn, opts)
      end,
      "user_fragment_request" => fn ->
        %{status: 200} = Absinthe.Plug.call(user_fragment_conn, opts)
      end,
      "node_request" => fn ->
        %{status: 200} = Absinthe.Plug.call(node_conn, opts)
      end,
    })
  end

  def plug_parser(conn) do
    opts = Plug.Parsers.init(
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      json_decoder: Poison
    )
    Plug.Parsers.call(conn, opts)
  end
end
