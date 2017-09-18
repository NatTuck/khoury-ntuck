defmodule Shop.Shop.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Shop.Shop.Product


  schema "products" do
    field :desc, :string
    field :name, :string
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:name, :price, :desc])
    |> validate_required([:name, :price, :desc])
  end
end
