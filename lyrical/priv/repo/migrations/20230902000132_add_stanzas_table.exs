defmodule Lyrical.Repo.Migrations.AddStanzasTable do
  use Ecto.Migration

  def change do
    create table(:stanzas) do
      add :song_id, references(:songs), null: false
      add :ordinal, :integer, null: false
      add :lines, {:array, :text}, null: false
    end

    create index(:stanzas, :song_id)
    create unique_index(:stanzas, [:song_id, :ordinal])
  end
end
