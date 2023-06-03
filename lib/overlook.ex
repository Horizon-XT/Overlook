defmodule Overlook do
  alias Overlook.User

  @moduledoc """
  Documentation for `Overlook`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Overlook.hello()
      :world

  """
  def hello do
    :world

    IO.puts("Hello Danny! Wanna Play with us?")
  end

  def start() do
    name = IO.gets("Username:") |> String.trim()
    password = IO.gets("Password:") |> String.trim() |> User.encrypt_password()
    email = IO.gets("Email:") |> String.trim()

    user = User.create_user(name, password, email)

    User.raw_print(user)
  end
end
