defmodule TaskManagerWeb.Utils.Utils do
  alias TaskManager.Tasks

  @doc """
  Gets a list of statuses and formats it for `<select>`.
  """
  def task_status_options do
    statuses = Tasks.list_statuses() |> Enum.filter(& &1)
    [{"All Tasks", "all"}] ++ Enum.map(statuses, &{String.capitalize(&1) <> " tasks", &1})
  end
end
