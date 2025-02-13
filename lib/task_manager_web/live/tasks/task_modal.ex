defmodule TaskManagerWeb.Tasks.TaskModal do
  use TaskManagerWeb, :live_component

  alias TaskManager.Tasks

  def render(assigns) do
    ~H"""
    <div id="modal" class="fixed inset-0 flex items-center justify-center bg-gray-900 bg-opacity-50">
      <div class="bg-white p-6 rounded-lg shadow-lg w-1/3">
        <h2 class="text-lg font-semibold mb-4">Create task</h2>

        <.form :let={f} for={@changeset} phx-submit="save" phx-target={@myself}>
          <.input field={f[:title]} label="Title" />
          <.input field={f[:description]} label="Description" type="textarea" />
          <.input field={f[:status]} label="Status" type="select" options={["pending", "completed"]} />
          <div class="flex justify-end mt-4">
            <button
              type="button"
              class="px-4 py-2 bg-gray-400 text-white rounded mr-2 hover:bg-gray-500"
              phx-click="close_modal"
            >
              Cancel
            </button>
            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
              Save
            </button>
          </div>
        </.form>
      </div>
    </div>
    """
  end

  def update(%{task: nil} = assigns, socket) do
    {:ok, assign(socket, assigns |> Map.put(:changeset, Tasks.empty_changeset()))}
  end

  def update(%{task: task} = assigns, socket) do
    changeset = Tasks.change_task(task)
    {:ok, assign(socket, assigns |> Map.put(:changeset, changeset))}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    case Tasks.create_task(task_params) do
      {:ok, _task} ->
        send(self(), :reload)
        {:noreply, push_patch(socket, to: "/tasks")}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
