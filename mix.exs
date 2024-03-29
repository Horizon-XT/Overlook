defmodule Overlook.MixProject do
  use Mix.Project

  def project do
    [
      app: :overlook,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:argon2_elixir, "~> 4.0"},
      {:phoenix, override: false}
    ]
  end
end
