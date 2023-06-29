defmodule Overlook.Password do
  @required_keys [:hash, :service, :key]

  @enforce_keys @required_keys
  defstruct @required_keys ++ [:linked_id]

  def create_password(password, service, key) do
    %Overlook.Password{
      hash: password,
      service: service,
      key: key,
      linked_id: ""
    }
  end

  def generate_key(password) do
    salt = :crypto.strong_rand_bytes(16)
    iterations = 10000
    key_len = 32

    :crypto.pbkdf2_hmac(:sha256, password, salt, iterations, key_len)
    |> Base.encode64()
  end

  defp generate_tag(cipher_text, key) do
    :crypto.mac(:hmac, :sha256, key, cipher_text)
  end

  defp authenticate_tag(tag, cipher_text, key) do
    if tag == generate_tag(cipher_text, key) do
      IO.puts("\n>>>Data is safe\n")
    else
      IO.puts("\n>>>Data is compromised\n")
    end
  end

  defp build_encrypted_str(i, e, t, a, m) do
    [i, e, t, a, m]
    |> Enum.join(";")
    |> Base.encode64()
  end

  defp decompose_encrypted_str(hash) do
    {:ok, decoded} = Base.decode64(hash)

    decoded
    |> String.split(";")
    |> List.to_tuple()
  end

  def encrypt_password(key, plain_text) do
    {:ok, k} = Base.decode64(key)
    iv = :crypto.strong_rand_bytes(12)
    aad = :crypto.strong_rand_bytes(16)

    {encrypted, tag} =
      :crypto.crypto_one_time_aead(:chacha20_poly1305, k, iv, plain_text, aad, true)

    mtag = generate_tag(encrypted, key)

    build_encrypted_str(iv, encrypted, tag, aad, mtag)
  end

  def decrypt_password(key, encoded_cipher_text) do
    {:ok, k} = Base.decode64(key)
    {iv, cipher_text, tag, aad, mtag} = decompose_encrypted_str(encoded_cipher_text)

    authenticate_tag(mtag, cipher_text, key)

    :crypto.crypto_one_time_aead(:chacha20_poly1305, k, iv, cipher_text, aad, tag, false)
  end

  def hash_password(password) do
    Argon2.hash_pwd_salt(password)
    |> Base.encode64()
  end
end
