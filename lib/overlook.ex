defmodule Overlook do
  alias Overlook.{User, SecretManager}

  def hello do
    :world

    IO.puts("Hello Danny! Do you wanna play with us?")
  end

  def demo() do
    # name = IO.gets("Name:") |> String.trim()
    # password = IO.gets("SecretManager:") |> String.trim() |> Password.hash_password()
    # email = IO.gets("Email:") |> String.trim()

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    name = "Link"
    secret = SecretManager.hash("zelda123") |> Base.encode64()
    email = "link@hyrule.com"

    user = User.create_user(name, secret, email)

    User.raw_print(user)

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    IO.puts(">>> Registering a new secret")
    user = User.register_new_secret("banana", "gmail", user)

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

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    IO.puts(">>> User Secrets")
    User.raw_print(user)

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )
  end

  def start() do
    IO.puts("Real App goes here")
  end

  def main() do
    start()
  end
end
