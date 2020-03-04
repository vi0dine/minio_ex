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

  @doc """
  Presigns a put object and provides a url
  """
  def presign_put_object(%Minio{} = client, opts),
    do: Signer.presigned_url(client, :put, opts)

  @doc """
  Presigns a get object and provides a url
  """
  def presign_get_object(%Minio{} = client, opts),
    do: Signer.presigned_url(client, :get, opts)
end
