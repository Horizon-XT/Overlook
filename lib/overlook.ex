defmodule Overlook do
  alias Overlook.{User, Password}

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

    IO.puts("Hello Danny! Do you wanna play with us?")
  end

  def start() do
    # name = IO.gets("Name:") |> String.trim()
    # password = IO.gets("Password:") |> String.trim() |> Password.hash_password()
    # email = IO.gets("Email:") |> String.trim()

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    name = "Link"
    password = Password.hash_password("zelda123") |> Base.encode64()
    email = "link@hyrule.com"

    user = User.create_user(name, password, email)

    User.raw_print(user)

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    user = User.register_new_password("banana", "gmail", user)

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    IO.puts(">>> Authorizing user")
    IO.puts(User.authenticate_user("zelda123", user.hash))

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    IO.puts(">>> User services")
    IO.puts(User.service_list(user))
  end

  def main() do
    start()
  end
end
