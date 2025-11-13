defmodule Streamlet.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :title, :string
      add :description, :text
      add :filename, :string
      add :content_type, :string
      add :size, :bigint
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
