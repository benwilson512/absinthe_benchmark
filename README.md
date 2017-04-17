# AbsintheBenchmark

To get average times using Benchee, run:
```
mix run -e "AbsinthePlugBenchmark.benchmark"
```
To get a detailed breakdown of function call times using `Mix.Tasks.Profile.Fprof.profile(fun, [sort: "own"])`, run:
```
mix run -e "AbsinthePlugBenchmark.profile"
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `absinthe_benchmark` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:absinthe_benchmark, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/absinthe_benchmark](https://hexdocs.pm/absinthe_benchmark).
