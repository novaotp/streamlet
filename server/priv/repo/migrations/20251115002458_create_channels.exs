defmodule Streamlet.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :name, :string, null: false
      add :handle, :string, null: false
      add :is_verified, :boolean, null: false

      add :description, :text
      add :avatar_key, :string
      add :banner_key, :string

      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:channels, [:handle])
  end
end
