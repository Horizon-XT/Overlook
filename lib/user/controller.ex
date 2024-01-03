defmodule Overlook.User.Controller do
  alias Overlook.{User, Secret}

  defp hash(secret) do
    Argon2.hash_pwd_salt(secret)
  end

  def create_user(name, passphrase, e) do
    hash = hash(passphrase) |> Base.encode64()
    User.Model.create(name, hash, e)
  end

  defp verify_pass(secret, stored_hash) do
    Argon2.verify_pass(secret, stored_hash)
  end

  def authenticate_user(secret, stored_encoded_hash) do
    {:ok, hash} = Base.decode64(stored_encoded_hash)

    verify_pass(secret, hash)
  end

  def register_new_secret(plain_text, service, user) do
    secret = Secret.Controller.create(plain_text, service, user.hash)

    updated_secrets = [secret | user.secrets]

    %{user | secrets: updated_secrets}
  end

  def retrieve_secret_by_service(service, user) do
    secret = Enum.filter(user.secrets, fn sct -> sct.service == service end) |> List.first()

    Secret.Controller.decrypt(secret.key, secret.hash)
  end

  def service_list(user) do
    Enum.map(user.secrets, fn pass -> pass.service end)
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
end
