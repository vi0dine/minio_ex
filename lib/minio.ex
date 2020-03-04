defmodule Minio do
  defstruct endpoint: nil,
            access_key: nil,
            secret_key: nil,
            request_datetime: DateTime.utc_now(),
            region: nil

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
