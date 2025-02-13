defmodule TaskManagerWeb.TasksLive do
  use TaskManagerWeb, :live_view

  alias TaskManager.Tasks
  alias TaskManagerWeb.Tasks.TaskModal

  def mount(_params, _session, socket) do
    {:ok, assign(socket, tasks: Tasks.list_tasks(), show_modal: false, task: nil)}
  end

  def handle_event("open_modal", %{"action" => action}, socket) do
    task = if action == "edit", do: Tasks.get_task!(socket.assigns.task_id), else: %Tasks.Task{}
    {:noreply, assign(socket, show_modal: true, task: task)}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  def handle_info(:reload, socket) do
    {:noreply, assign(socket, tasks: Tasks.list_tasks())}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-4">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-semibold text-gray-800">Tasks</h2>
        <button
          class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
          phx-click="open_modal"
          phx-value-action="new"
        >
          + Create Task
        </button>
      </div>

      <.table id="tasks" rows={@tasks}>
        <:col :let={task} label="ID"><%= task.id %></:col>
        <:col :let={task} label="Title"><%= task.title %></:col>
        <:col :let={task} label="Description"><%= task.description %></:col>
        <:col :let={task} label="Status"><%= task.status %></:col>
        <%!-- <:col :let={task} label="User"><%= task.user.email %></:col> --%>
        <:action :let={task}>
          <button
            phx-click="open_modal"
            phx-value-action="edit"
            phx-value-task_id={task.id}
            class="text-blue-600 hover:text-blue-800"
          >
            Edit
          </button>
        </:action>
      </.table>

      <%= if @show_modal do %>
        <.live_component module={TaskModal} id="task_modal" task={@task} />
      <% end %>
    </div>
    """
  end
end
