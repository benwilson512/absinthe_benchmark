defmodule AbsintheBenchmark.Mixfile do
  use Mix.Project

  def project do
    [app: :absinthe_benchmark,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
   [
    #  {:absinthe, github: "absinthe-graphql/absinthe", branch: "v1.3", override: true},
    #  {:absinthe_plug, github: "absinthe-graphql/absinthe_plug", branch: "v1.3", override: true},
    #  {:absinthe_relay, github: "absinthe-graphql/absinthe_relay", branch: "v1.3", override: true},
     {:absinthe, path: "../absinthe", override: true},
     {:absinthe_plug, path: "../absinthe_plug", override: true},
     {:absinthe_relay, path: "../absinthe_relay", override: true},
     {:poison, "~> 2.1.0"},
     {:benchee, ">= 0.0.0"},
   ]
  end
end
