defmodule Overlook do
  alias Overlook.{User, Secret}

  def hello do
    :world

    IO.puts("Hello Danny! Do you wanna play with us?")
  end

  def demo() do
    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    name = "Link"
    passphrase = "zelda123"
    email = "link@hyrule.com"

    user = User.Controller.create_user(name, passphrase, email)

    User.Controller.print(user)

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    IO.puts(">>> Registering a new secret")
    user = User.Controller.register_new_secret("banana", "gmail", user)

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    IO.puts(">>> Authorizing user")
    IO.puts(User.Controller.authenticate_user("zelda123", user.hash))

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    IO.puts(">>> User services")
    IO.puts(User.Controller.service_list(user))

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    IO.puts(">>> User Secrets")
    User.Controller.print(user)

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )

    IO.puts(">>> Retrieving secret by service")
    # TODO: validate service name!
    pass = User.Controller.retrieve_secret_by_service("gmail", user)
    IO.puts(pass)

    IO.puts(
      "\n---------------------------------------------------------------------------------\n"
    )
  end

  def start_server() do
    IO.puts("Real App goes here")
  end

  def main() do
    start_server()
  end
end
