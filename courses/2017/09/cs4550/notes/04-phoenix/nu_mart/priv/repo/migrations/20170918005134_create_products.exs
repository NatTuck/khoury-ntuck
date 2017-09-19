defmodule NuMart.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :price, :decimal, precision: 12, scale: 2
      add :desc, :text

      timestamps()
    end

  end
end
