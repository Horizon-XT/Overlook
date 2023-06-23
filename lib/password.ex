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

  def generate_key() do
    :crypto.strong_rand_bytes(32)
    |> Base.encode64()
  end

  defp build_encrypted_str(i, e, t, a) do
    encoded_iv = Base.encode64(i)
    encoded_encrypted = Base.encode64(e)
    encoded_tag = Base.encode64(t)
    encoded_aad = Base.encode64(a)

    encoded_iv <> ";" <> encoded_encrypted <> ";" <> encoded_tag <> ";" <> encoded_aad
    |> Base.encode64()
  end

  defp decompose_encrypted_str(hash) do
    {:ok, decoded} = Base.decode64(hash)
    params = String.split(decoded, ";")
    
    [i64, e64, t64, a64] = params
    
    {:ok, i} = Base.decode64(i64)
    {:ok, e} = Base.decode64(e64)
    {:ok, t} = Base.decode64(t64)
    {:ok, a} = Base.decode64(a64)

    {i, e, t, a}
  end

  def encrypt_password(key, plain_text) do
    {:ok, k} = Base.decode64(key)
    iv = :crypto.strong_rand_bytes(16)
    aad = :crypto.strong_rand_bytes(16)
    
    {encrypted, tag} = :crypto.crypto_one_time_aead(:aes_256_gcm, k, iv, plain_text, aad, true)

    build_encrypted_str(iv, encrypted, tag, aad)
  end

  def decrypt_password(key, encoded_cipher_text) do
    {:ok, k} = Base.decode64(key)
    {iv, cipher_text, tag, aad} = decompose_encrypted_str(encoded_cipher_text)
  
    :crypto.crypto_one_time_aead(:aes_256_gcm, k, iv, cipher_text, aad, tag, false)
  end

  def hash_password(password) do
    Argon2.hash_pwd_salt(password)
    |> Base.encode64()
  end
end
