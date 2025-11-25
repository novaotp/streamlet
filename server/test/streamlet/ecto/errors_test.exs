defmodule Streamlet.Ecto.ErrorsTest do
  use ExUnit.Case

  alias Streamlet.Ecto.Errors

  defmodule FakeSchema do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field :name, :string
      field :email, :string
      field :age, :integer
    end

    @doc false
    def changeset(struct, attrs \\ %{}) do
      struct
      |> cast(attrs, [:name, :email, :age])
      |> validate_required([:name, :email])
      |> validate_format(:email, ~r/@/)
      |> validate_number(:age, greater_than: 0)
    end
  end

  test "mapper/1 returns the param if the param is not a changeset" do
    assert Errors.mapper(1) == 1
    assert Errors.mapper("hello") == "hello"
  end

  test "mapper/1 returns an empty map for a valid changeset" do
    changeset = FakeSchema.changeset(%FakeSchema{}, %{name: "valid name", email: "validemail@example.com", age: 20})

    assert changeset.valid?
    assert %{} = Errors.mapper(changeset)
  end

  test "mapper/1 returns a map for an erroneous changeset" do
    changeset = FakeSchema.changeset(%FakeSchema{})

    assert not changeset.valid?
    assert %{
        name: ["can't be blank"],
        email: ["can't be blank"]
      } = Errors.mapper(changeset)
  end
end
