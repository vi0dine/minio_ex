defmodule Minio.MixProject do
  use Mix.Project

  def project do
    [
      app: :minio,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      name: "minio",
      source_url: "https://github.com/srivathsanmurali/minio_ex"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19.1", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "A client library to use the Minio API"
  end

  defp package() do
    [
      name: "minio",
      maintainers: ["Srivathsan Murali"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/srivathsanmurali/minio_ex"}
    ]
  end
end
