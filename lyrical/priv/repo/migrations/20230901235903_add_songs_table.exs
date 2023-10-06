defmodule Lyrical.Repo.Migrations.AddSongsTable do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :title, :text, null: false
      add :album, :text, null: false
      add :artist, :text, null: false
      add :year, :integer, null: false
      add :artwork_url, :text, null: false
    end
  end
end
