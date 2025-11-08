defmodule Streamlet.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :token, :string
      add :expires_at, :utc_datetime
      add :user_id, references :users

      timestamps(type: :utc_datetime)
    end
  end
end
