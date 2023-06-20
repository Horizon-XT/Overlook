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
    "User Info:\nName: #{user.name}\nPassword Hash: #{user.hash}\nEmail: #{user.email}\nPasswords:"
    |> IO.puts()

    Enum.map(user.passwords, fn p ->
      IO.puts(
        "{\nHash:#{p.hash}\nService:#{p.service}}\nKey:#{p.key}\nLinked ID(email/username):#{p.linked_id}\n}"
      )
    end)
  end

  def register_new_password(password, service, user) do
    new_password = Password.create_password(password, service)
    updated_passwords = [new_password | user.passwords]
    %{user | passwords: updated_passwords}
  end
end
