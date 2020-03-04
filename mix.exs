defmodule Minio.MixProject do
  use Mix.Project

  def project do
    [
      app: :minio,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19.1", only: :dev, runtime: false}
    ]
  end
end
