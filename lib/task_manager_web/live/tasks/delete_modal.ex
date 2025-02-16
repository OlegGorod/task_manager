defmodule TaskManagerWeb.Tasks.DeleteModal do
  use TaskManagerWeb, :live_component
  alias TaskManager.Tasks

  def handle_event("delete_task", _, socket) do
    case Tasks.delete_task(socket.assigns.task) do
      {:ok, _} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{}} ->
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div
      id="delete_modal"
      class="fixed inset-0 flex items-center justify-center bg-gray-900 bg-opacity-50"
      phx-click="close_delete_modal"
    >
      <div
        id="stop-propagation"
        class="bg-white p-6 rounded-lg shadow-lg w-11/12 max-w-xl text-center"
        phx-hook="StopPropagation"
      >
        <h2 class="text-lg font-semibold mb-4">Are you sure you want to delete this task?</h2>
        <p class="text-gray-600 mb-6">This action cannot be undone.</p>

        <div class="flex justify-center gap-4">
          <button
            type="button"
            class="px-4 py-2 bg-gray-400 text-white rounded hover:bg-gray-500"
            phx-click="close_delete_modal"
          >
            Cancel
          </button>
          <button
            type="button"
            class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
            phx-click="delete_task"
            phx-target={@myself}
          >
            Confirm
          </button>
        </div>
      </div>
    </div>
    """
  end
end
