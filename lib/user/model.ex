defmodule Overlook.User.Model do
  @required_keys [:name, :hash, :email]

  @enforce_keys @required_keys
  defstruct @required_keys ++ [:secrets]

  def create(name, hash, email) do
    %Overlook.User.Model{
      name: name,
      hash: hash,
      email: email,
      secrets: []
    }
  end
end
