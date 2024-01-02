defmodule Overlook.Secret.Controller do
  alias Overlook.Secret
  alias Overlook.Services

  def create(encrypted_secret, service, key) do
    Secret.Model.create(encrypted_secret, service, key)
  end

  def generate_key(secret) do
    Services.Crypto.generate_key(secret)
  end

  def encrypt(key, plain_text) do
    Services.Crypto.encrypt_secret(key, plain_text)
  end

  def decrypt(key, encoded_cipher_text) do
    Services.Crypto.decrypt_secret(key, encoded_cipher_text)
  end
end
