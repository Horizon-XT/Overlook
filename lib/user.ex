defmodule Overlook.User do
  alias Argon2
  alias Overlook.Password

  @required_keys [:name, :hash, :email]

  @enforce_keys @required_keys
  defstruct @required_keys ++ [:passwords]

  def create_user(name, hash, email) do
    %Overlook.User{
      name: name,
      hash: hash,
      email: email,
      passwords: []
    }
  end

  def raw_print(user) do
    "User Info\nName: #{user.name}\nPassword Hash: #{user.hash}\nEmail: #{user.email}\nPasswords:"
    |> IO.puts()

    Enum.map(user.passwords, fn p ->
      IO.puts(
        "{\nPassword: #{p.hash}\nService: #{p.service}\nKey: #{p.key}\nLinked ID(email/username): #{p.linked_id}\n}"
      )
    end)
  end

  def register_new_password(plain_text, service, user) do
    key = Password.generate_key(user.hash)

    encrypted_password = Password.encrypt_password(key, plain_text)

    new_password = Password.create_password(encrypted_password, service, key)

    updated_passwords = [new_password | user.passwords]

    %{user | passwords: updated_passwords}
  end

  def authenticate_user(password, stored_encoded_hash) do
    {:ok, hash} = Base.decode64(stored_encoded_hash)

    Password.verify_pass(password, hash)
  end
end
