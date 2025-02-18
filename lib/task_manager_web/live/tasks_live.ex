defmodule TaskManagerWeb.TasksLive do
  use TaskManagerWeb, :live_view

  alias TaskManager.Tasks
  alias TaskManagerWeb.Tasks.TaskModal
  alias TaskManagerWeb.Tasks.DeleteModal
  alias TaskManagerWeb.Utils.Utils

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(TaskManager.PubSub, "tasks")
      Phoenix.PubSub.subscribe(TaskManager.PubSub, "presence:tasks")

      if socket.assigns[:current_user] do
        TaskManagerWeb.Presence.track(self(), "presence:tasks", socket.id, %{
          user: socket.assigns.current_user.email
        })
      end
    end

    {:ok,
     assign(socket,
       tasks: Tasks.list_tasks_by_status("all"),
       show_modal: false,
       show_delete_modal: false,
       selected_filter: "all",
       status_options: Utils.task_status_options(),
       task: nil,
       current_user: socket.assigns.current_user,
       action: "",
       online_users: 0
     )}
  end

  def handle_event("filter_tasks", %{"status_filter" => filter}, socket) do
    {:noreply, assign(socket, tasks: Tasks.list_tasks_by_status(filter), selected_filter: filter)}
  end

  def handle_event("open_modal", %{"action" => action} = params, socket) do
    task_id = Map.get(params, "task_id")
    task = if action == "edit" and task_id, do: Tasks.get_task!(task_id), else: %Tasks.Task{}
    {:noreply, assign(socket, show_modal: true, task: task, action: action)}
  end

  def handle_event("open_delete_modal", %{"task_id" => id}, socket) do
    task = Tasks.get_task!(id)

    {:noreply, assign(socket, show_delete_modal: true, task: task)}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  def handle_event("close_delete_modal", _, socket) do
    {:noreply, assign(socket, show_delete_modal: false)}
  end

  def handle_info({Tasks, [:task, _created_updated_deleted], _task}, socket) do
    {:noreply,
     assign(socket,
       tasks: Tasks.list_tasks_by_status("all"),
       show_modal: false,
       show_delete_modal: false
     )}
  end

  def handle_info(%{event: "presence_diff", topic: topic}, socket) do
    online_users_count =
      TaskManagerWeb.Presence.list(topic)
      |> Map.values()
      |> Enum.flat_map(& &1.metas)
      |> Enum.map(& &1.user)
      |> Enum.uniq()
      |> length()

    {:noreply, assign(socket, online_users: online_users_count)}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-4">
      <div class="mb-4 flex flex-col justify-between gap-1 sm:flex sm:items-center sm:flex-row">
        <div class="flex flex-row justify-between gap-1 items-center sm:justify-start sm:gap-4">
          <h2 class="text-xl font-semibold text-gray-dark">Tasks</h2>
          <span class="text-gray-600"><%= @online_users %> users online</span>
        </div>

        <div class="flex flex-row justify-between items-center gap-1 sm:justify-start sm:gap-4">
          <form phx-change="filter_tasks">
            <.input
              type="select"
              name="status_filter"
              options={@status_options}
              value={@selected_filter}
            />
          </form>

          <button
            class="px-4 py-2 bg-primary text-white font-bold text-base rounded-lg shadow-md hover:bg-primary-hover transition-all duration-300 whitespace-nowrap"
            phx-click="open_modal"
            phx-value-action="new"
          >
            + Create Task
          </button>
        </div>
      </div>

      <%= if(@tasks != []) do %>
        <.table id="tasks" rows={@tasks}>
          <:col :let={task} label="ID"><%= task.id %></:col>
          <:col :let={task} label="Title"><%= task.title %></:col>
          <:col :let={task} label="Description"><%= task.description %></:col>
          <:col :let={task} label="Status">
            <span class={"px-1 py-1 sm:px-4 sm:py-2 text-white rounded #{if task.status == "completed", do: "bg-primary", else: "bg-gray-dark"}"}>
              <%= task.status %>
            </span>
          </:col>
          <:col :let={task} label="User"><%= task.user.email %></:col>
          <:action :let={task}>
            <button
              phx-click="open_modal"
              phx-value-action="edit"
              phx-value-task_id={task.id}
              class="font-bold text-success hover:text-success-hover"
            >
              Edit
            </button>
            <button
              type="button"
              class="font-bold text-danger hover:text-danger-hover"
              phx-value-task_id={task.id}
              phx-click="open_delete_modal"
            >
              Delete
            </button>
          </:action>
        </.table>
      <% else %>
        <p class="text-gray-500 text-center py-4">No tasks available.</p>
      <% end %>

      <%= if @show_modal do %>
        <.live_component
          module={TaskModal}
          id="task_modal"
          task={@task}
          current_user={@current_user}
          action={@action}
        />
      <% end %>
      <%= if @show_delete_modal do %>
        <.live_component module={DeleteModal} id="delete_modal" task={@task} />
      <% end %>
    </div>
    """
  end
end
