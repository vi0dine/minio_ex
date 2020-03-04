# Minio
This package implements the Minio API.

## Implemented API fucntions
The following api functions are implemented.

### Presigned Operations
  + presign_put_object
  + presign_get_object

      *The package is being developed as necessary for my personal use. If
      you require any api endpoint to be added, please add an issue and
      send a PR if you have the time.*

## Usage
To use the api a client struct must be created. This can be done the
following way.

```elixir
client = %Minio{
endpoint: "https://play.min.io",
access_key: "Q3AM3UQ867SPQQA43P2F",
secret_key: "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG",
region: "us-east-1"
}
```
The region has to be specified. It is not automatically retreived.
The default region is set to "us-east-1"

Once the client sturct is created, the following api functions can
be used.

### Pesigned Put Object
Generate a presigned url to put an object to an minio instance.

```elixir
{:ok, put_url} = Minio.presign_put_object(client, bucket_name: "test", object_name: "test3.png")
```

### Presigned Get Object
Generate a presigned url to get an object from an minio instance.
```elixir
{:ok, get_url} = Minio.presign_get_object(client, bucket_name: "test", object_name: "test3.png")
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `minio` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:minio, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). The docs can be found at
[https://hexdocs.pm/minio](https://hexdocs.pm/minio).

