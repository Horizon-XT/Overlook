defmodule Overlook.User do
  alias Argon2

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
    "User Info:\n#{user.name}\n#{user.hash}\n#{user.email}"
    |> IO.puts()
  end

  def encrypt_password(password) do
    Argon2.hash_pwd_salt(password)
  end
end
