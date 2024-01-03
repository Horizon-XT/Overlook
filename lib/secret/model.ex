defmodule Overlook.Secret.Model do
  @required_keys [:hash, :service, :key]

  @enforce_keys @required_keys
  defstruct @required_keys ++ [:linked_id]

  def create(hash, service, key) do
    %Overlook.Secret.Model{
      hash: hash,
      service: service,
      key: key,
      linked_id: ""
    }
  end
end
