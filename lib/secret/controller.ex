defmodule Overlook.Secret.Controller do
  alias Overlook.Secret
  alias Overlook.Services

  defp generate_key(secret) do
    Services.Crypto.generate_key(secret)
  end

  defp encrypt(key, plain_text) do
    Services.Crypto.encrypt_secret(key, plain_text)
  end

  def create(plain_text, service, hash) do
    key = generate_key(hash)

    encrypted_secret = encrypt(key, plain_text)

    Secret.Model.create(encrypted_secret, service, key)
  end

  def decrypt(key, encoded_cipher_text) do
    Services.Crypto.decrypt_secret(key, encoded_cipher_text)
  end
end
