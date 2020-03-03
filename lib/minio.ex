defmodule Minio do
  defstruct endpoint: nil,
            access_key: nil,
            secret_key: nil,
            request_datetime: DateTime.utc_now(),
            region: nil

  @sign_v4_algo "AWS4-HMAC-SHA256"
  @unsigned_payload "UNSIGNED-PAYLOAD"

  def hmac(key, data), do: :crypto.hmac(:sha256, key, data)
  def sha256(data), do: :crypto.hash(:sha256, data)
  def hex_digest(data), do: Base.encode16(data, case: :lower)

  def request_date(client),
    do:  
    client.request_datetime
    |> DateTime.to_date()
    |> Date.to_iso8601(:basic)

  def request_datetime(client),
    do:
      #%{DateTime.utc_now() | hour: 0, minute: 0, second: 0, microsecond: {0, 0}}
      %{client.request_datetime | microsecond: {0,0}}
      |> DateTime.to_iso8601(:basic)

  def get_target_url(%Minio{} = client, bucket_name: bucket_name, object_name: object_name) do
    "#{client.endpoint}/#{bucket_name}/#{object_name}"
  end

  defp is_valid_bucket_name("") do
    {:error, "Bucket name can't be blank"}
  end

  defp is_valid_bucket_name(name) when is_bitstring(name) do
    cond do
      String.length(name) < 3 -> {:error, "Bucket name can't be less than 3 characters"}
      String.length(name) > 63 -> {:error, "Bucket name can't be more than 63 characters"}
      true -> :ok
    end
  end

  defp is_valid_bucket_name(_), do: {:error, "Bucket name must be a string"}

  defp is_valid_object_name(""), do: {:error, "Object name can't be blank"}
  defp is_valid_object_name(name) when is_bitstring(name), do: :ok
  defp is_valid_object_name(_), do: {:error, "Object name must be a string"}

  defp get_signed_headers(headers) do
    headers
    |> Map.keys()
    |> Enum.map(&String.downcase/1)
    |> Enum.sort()
    |> Enum.join(";")
  end

  defp get_scope(client) do
    [
      request_date(client),
      client.region,
      "s3",
      "aws4_request"
    ]
    |> Enum.join("/")
  end

  defp credential(client) do
    client.access_key <> "/" <> get_scope(client)
  end

  def get_query(client, headers) do
    %{
      "X-Amz-Algorithm" => @sign_v4_algo,
      "X-Amz-Credential" => credential(client),
      "X-Amz-Date" => request_datetime(client),
      "X-Amz-Expires" => "604800",
      "X-Amz-SignedHeaders" => get_signed_headers(headers)
    }
    |> URI.encode_query()
  end

  defp get_canonical_rquest(method, uri, headers) do
    [
      method |> Atom.to_string() |> String.upcase(),
      uri.path,
      uri.query,
    ]
    |> Kernel.++(
      Enum.sort(headers)
      |> Enum.map(fn {k, v} ->
        "#{String.downcase(k)}:#{to_string(v) |> String.trim()}"
      end)
    )
    |> Kernel.++(["", get_signed_headers(headers), @unsigned_payload])
    |> Enum.join("\n")
  end

  def signing_key(client) do
    "AWS4#{client.secret_key}"
    |> hmac(request_date(client))
    |> hmac(client.region)
    |> hmac("s3")
    |> hmac("aws4_request")
  end

  def string_to_sign(client, canonical_request) do
    [
      @sign_v4_algo,
      request_datetime(client),
      get_scope(client),
      canonical_request
      |> sha256()
      |> hex_digest()
    ]
    |> Enum.join("\n")
  end

  defp get_host(%URI{host: host, port: nil}), do: to_string(host)
  defp get_host(%URI{host: host, port: port}), do: "#{host}:#{port}"

  def presigned_url(
        %Minio{} = client,
        method,
        opts
      ) do
    with :ok <- is_valid_bucket_name(opts[:bucket_name]),
         :ok <- is_valid_object_name(opts[:object_name]) do
      uri = get_target_url(client, opts) |> URI.parse()
      headers_to_sign = %{"Host" => get_host(uri)}
      new_uri = Map.put(uri, :query, get_query(client, headers_to_sign))

      string_to_sign =
        string_to_sign(
          client,
          get_canonical_rquest(method, new_uri, headers_to_sign)
        )

      signature =
        client
        |> signing_key()
        |> hmac(string_to_sign)
        |> hex_digest()

      "#{URI.to_string(new_uri)}&X-Amz-Signature=#{signature}"
    else
      err -> err
    end
  end
end
