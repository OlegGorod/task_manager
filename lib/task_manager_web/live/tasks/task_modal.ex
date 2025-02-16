defmodule TaskManagerWeb.Tasks.TaskModal do
  use TaskManagerWeb, :live_component

  alias TaskManager.Tasks

  def update(%{task: nil, current_user: user, action: action} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:current_user, user)
     |> assign(:action, action)
     |> assign(:changeset, Tasks.empty_changeset())}
  end

  def update(%{task: task} = assigns, socket) do
    changeset = Tasks.change_task(task)
    {:ok, assign(socket, assigns |> Map.put(:changeset, changeset))}
  end

  def handle_event("create", %{"task" => task_params}, socket) do
    task_params = Map.put(task_params, "user_id", socket.assigns.current_user.id)

    case Tasks.create_task(task_params) do
      {:ok, _task} ->
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("update", %{"task" => task_params}, socket) do
    case Tasks.update_task(socket.assigns.task, task_params) do
      {:ok, _task} ->
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <div
      id="modal"
      class="fixed inset-0 flex items-center justify-center bg-gray-900 bg-opacity-50"
      phx-click="close_modal"
    >
      <div
        id="stop-propagation"
        class="bg-white p-6 rounded-lg shadow-lg w-11/12 max-w-md"
        phx-hook="StopPropagation"
      >
        <h2 class="text-lg font-semibold mb-4">
          <%= if @action == "edit", do: "Edit task", else: "Create task" %>
        </h2>

        <.form
          :let={f}
          for={@changeset}
          phx-submit={if @action == "edit", do: "update", else: "create"}
          phx-target={@myself}
        >
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

            <button
              type="submit"
              class={"px-4 py-2 text-white rounded #{if @action == "edit", do: "bg-success hover:bg-success-hover", else: "bg-primary hover:bg-primary-hover"}"}
            >
              <%= if @action == "edit", do: "Update", else: "Create" %>
            </button>
          </div>
        </.form>
      </div>
    </div>
    """
  end
end
