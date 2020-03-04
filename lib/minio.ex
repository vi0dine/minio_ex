defmodule Minio do
  @moduledoc """
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
  """

  defstruct endpoint: nil,
            access_key: nil,
            secret_key: nil,
            region: "us-east-1"

  @type t :: %__MODULE__{
          endpoint: String.t(),
          access_key: String.t(),
          secret_key: String.t(),
          region: String.t()
        }

  alias Minio.Signer

  @spec presign_put_object(t, Keyword.t()) :: {:ok, String.t()} | {:error, String.t()}
  @doc """
  Presigns a put object and provides a url

  ## Options

    * `:bucket_name` - The name of the minio bucket.
    * `:object_name` - The object name or path.
    * `:request_datetime` - The datetime of request. Defaults to `DateTime.utc_now()`
    * `:link_expiry` - The number of seconds for link expiry. Defaults to `608_400` seconds.
  """
  def presign_put_object(%Minio{} = client, opts),
    do: Signer.presigned_url(client, :put, opts)

  @spec presign_get_object(t, Keyword.t()) :: {:ok, String.t()} | {:error, String.t()}
  @doc """
  Presigns a get object and provides a url
  
  ## Options

    * `:bucket_name` - The name of the minio bucket.
    * `:object_name` - The object name or path.
    * `:request_datetime` - The datetime of request. Defaults to `DateTime.utc_now()`
    * `:link_expiry` - The number of seconds for link expiry. Defaults to `608_400` seconds.
  """
  def presign_get_object(%Minio{} = client, opts),
    do: Signer.presigned_url(client, :get, opts)
end
