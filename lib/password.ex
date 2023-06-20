defmodule Overlook.Password do
  @required_keys [:hash, :service]

  @enforce_keys @required_keys
  defstruct @required_keys ++ [:key, :linked_id]

  def create_password(password, service) do
    %Overlook.Password{
      hash: password,
      service: service,
      key: "",
      linked_id: ""
    }
  end

  def hash_password(password) do
    Argon2.hash_pwd_salt(password)
  end
end
