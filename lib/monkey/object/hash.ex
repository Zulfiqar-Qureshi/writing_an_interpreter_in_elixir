defmodule Monkey.Object.Hash do
  alias Monkey.Object.Error
  alias Monkey.Object.Object

  @enforce_keys [:pairs]
  defstruct [:pairs] # %{Hash.Key, Hash.Pair}

  defmodule Key do
    @enforce_keys [:type, :value]
    defstruct [:type, :value]
  end

  defmodule Pair do
    @enforce_keys [:key, :value]
    defstruct [:key, :value]
  end

  defprotocol Hashable do
    @doc "Returns the hash key of the object"
    @fallback_to_any true
    def hash(obj)
  end

  defimpl Hashable, for: Any do
    def hash(obj) do
      %Error{message: "unusable as hash key: #{Object.type(obj)}"}
    end
  end

  defimpl Object, for: __MODULE__ do
    def type(_), do: "HASH"

    def inspect(obj) do
      pairs = obj.pairs
      |> Enum.map(fn({key, pair}) ->
        "#{Object.inspect(pair.key)}:#{Object.inspect(pair.value)}"
      end)
      |> Enum.join(", ")

      out = [
        "{",
        pairs,
        "}"
      ]

      Enum.join(out)
    end
  end
end