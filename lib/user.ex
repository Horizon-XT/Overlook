defmodule Overlook.User do
  @c_lib "./lib/argon.so"

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
    salt = :crypto.strong_rand_bytes(16) |> Base.encode64()
    System.cmd("c", ["#{@c_lib}", password, salt])
    |> elem(1)
    |> String.trim()
  end
end
