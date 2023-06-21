defmodule Overlook.Password do
  @required_keys [:hash, :service, :priv_key, :pub_key]

  @enforce_keys @required_keys
  defstruct @required_keys ++ [:linked_id]

  def create_password(password, service, priv_key, pub_key) do
    %Overlook.Password{
      hash: password,
      service: service,
      priv_key: priv_key,
      pub_key: pub_key,
      linked_id: ""
    }
  end

  def generate_rsa_key() do
    :crypto.generate_key(:rsa, {4096, 65537})
  end

  # This function was from taken from here:
  # https://stackoverflow.com/questions/22517250/how-to-convert-an-elixir-binary-to-a-string
  defp raw_binary_to_string(raw) do
    codepoints = String.codepoints(raw)

    val =
      Enum.reduce(codepoints, fn w, result ->
        cond do
          String.valid?(w) ->
            result <> w

          true ->
            <<parsed::8>> = w
            result <> <<parsed::utf8>>
        end
      end)

    val
  end

  def encrypt_password(key, plain_text) do
    :crypto.private_encrypt(:rsa_padding, plain_text, key, :rsa_pkcs1_padding)
    |> Base.encode64()
  end

  def decrypt_password(key, encoded_cipher_text) do
    cipher_text = Base.decode64(encoded_cipher_text)
    binary_hash = IO.inspect(cipher_text, binaries: :as_binaries)

    :crypto.private_decrypt(:rsa_padding, binary_hash, key, :rsa_opt)
    |> raw_binary_to_string()
  end

  def hash_password(password) do
    Argon2.hash_pwd_salt(password)
  end
end
