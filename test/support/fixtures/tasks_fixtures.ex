defmodule TaskManager.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskManager.Tasks` context.
  """

  alias TaskManager.Repo

  import TaskManager.AccountsFixtures

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    user = Map.get(attrs, :user) || user_fixture()

    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        status: "pending",
        title: "some title",
        user_id: user.id
      })
      |> TaskManager.Tasks.create_task()

    Repo.preload(task, :user)
  end
end
