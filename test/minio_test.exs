defmodule MinioTest do
  use ExUnit.Case
  doctest Minio

  test "greets the world" do
    assert Minio.hello() == :world
  end
end
