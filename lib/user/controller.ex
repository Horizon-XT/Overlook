defmodule Overlook.User.Controller do
  alias Overlook.{User, Secret}

  def create_user(n, h, e) do
    User.Model.create(n, h, e)
  end

  def hash(secret) do
    Argon2.hash_pwd_salt(secret)
  end

  def verify_pass(secret, stored_hash) do
    Argon2.verify_pass(secret, stored_hash)
  end

  def print(user) do
    "User Info\nName: #{user.name}\nSecret Hash: #{user.hash}\nEmail: #{user.email}\nSecrets:"
    |> IO.puts()

    Enum.map(user.secrets, fn p ->
      IO.puts(
        "{\nSecret: #{p.hash}\nService: #{p.service}\nKey: #{p.key}\nLinked ID(email/username): #{p.linked_id}\n}"
      )
    end)
  end

  def authenticate_user(secret, stored_encoded_hash) do
    {:ok, hash} = Base.decode64(stored_encoded_hash)

    verify_pass(secret, hash)
  end

  def register_new_secret(plain_text, service, user) do
    key = Secret.Controller.generate_key(user.hash)

    encrypted_secret = Secret.Controller.encrypt(key, plain_text)

    new_secret = Secret.Controller.create(encrypted_secret, service, key)

    updated_secrets = [new_secret | user.secrets]

    %{user | secrets: updated_secrets}
  end

  def service_list(user) do
    Enum.map(user.secrets, fn pass -> pass.service end)
  end
end
