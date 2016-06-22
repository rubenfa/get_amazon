defmodule GetAmazon.Mixfile do
  use Mix.Project

  def project do
    [app: :get_amazon,
     version: "0.0.1",
     elixir: "~> 1.2",
     #build_embedded: Mix.env == :prod,
     #sotart_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.8.0"},
     # {:floki, "~> 0.8.1"},
     {:chronos, "~> 1.5.1"},
     {:sweet_xml, "~> 0.6.1"}
    ]
  end
end
