defmodule TaskManager.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field(:status, :string)
    field(:description, :string)
    field(:title, :string)

    belongs_to(:user, TaskManager.Accounts.User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :status, :user_id])
    |> validate_required([:title, :description, :status, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
