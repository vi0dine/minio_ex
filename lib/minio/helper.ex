defmodule Minio.Helper do
  
  @doc "HMAC-SHA256 hash computation helper"
  def hmac(key, data),
    do: :crypto.hmac(:sha256, key, data)

  @doc "SHA256 hash computation helper"
  def sha256(data),
    do: :crypto.hash(:sha256, data)

  @doc "encode data into hex code"
  def hex_digest(data),
    do: Base.encode16(data, case: :lower)

  @doc "Convert date to iso8601 string"
  def iso8601_date(datetime),
    do:
      datetime
      |> DateTime.to_date()
      |> Date.to_iso8601(:basic)

  @doc "Convert datetime to iso8601 string"
  def iso8601_datetime(datetime),
    do:
      %{datetime | microsecond: {0, 0}}
      |> DateTime.to_iso8601(:basic)

  @doc """
  Construct result url based on the endpoint, bucket name and object name.
  """
  def get_target_uri(endpoint, opts \\ []) do
    path = case opts do
      [bucket_name: bucket_name, object_name: object_name] ->
        "#{bucket_name}/#{object_name}"
      [bucket_name: bucket_name] ->
        "#{bucket_name}"
      _ -> ""
    end

    endpoint
    |> URI.parse()
    |> URI.merge(path)
  end

  @doc """
  Return host form parsed URI with port only visible if port is not
  one of the default ports.
  """
  def remove_default_port(%URI{host: host, port: port}) when port in [80, 443],
    do: to_string(host)

  def remove_default_port(%URI{host: host, port: port}),
    do: "#{host}:#{port}"
  
  @doc """
  Checks if the bucketname provided is valid
  """
  def is_valid_bucket_name("") do
    {:error, "Bucket name can't be empty"}
  end

  def is_valid_bucket_name(name) when is_bitstring(name) do
    cond do
      String.length(name) < 3 -> {:error, "Bucket name can't be less than 3 characters"}
      String.length(name) > 63 -> {:error, "Bucket name can't be more than 63 characters"}
      true -> :ok
    end
  end

  def is_valid_bucket_name(_), do: {:error, "Bucket name must be a string"}


  @doc """
  checks if the objectname provided is valid
  """
  def is_valid_object_name(""), do: {:error, "Object name can't be empty"}
  def is_valid_object_name(name) when is_bitstring(name), do: :ok
  def is_valid_object_name(_), do: {:error, "Object name must be a string"}
end
