defmodule Streamlet.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :name, :string
      add :slug, :string
      add :description, :text
      add :avatar_key, :string
      add :banner_key, :string
      add :is_verified, :boolean
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:channels, [:slug])
  end
end
