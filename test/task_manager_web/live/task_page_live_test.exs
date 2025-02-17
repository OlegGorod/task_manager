defmodule TaskManagerWeb.TaskPageLiveTest do
  use TaskManagerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import TaskManager.TasksFixtures

  setup [:register_and_log_in_user]

  test "displays tasks in the table", %{conn: conn, user: user} do
    task = task_fixture(%{user: user})
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "td", "#{task.id}")
    assert has_element?(view, "td", task.title)
    assert has_element?(view, "td", task.description)
    assert has_element?(view, "td", task.status)
    assert has_element?(view, "td", user.email)
  end

  test "open create task modal", %{conn: conn} do
    new_title = "New Task Title"
    new_description = "New Task description"

    {:ok, view, _html} = live(conn, ~p"/")

    view |> element("button[phx-click=open_modal][phx-value-action=new]") |> render_click()

    assert has_element?(view, "#modal")

    view
    |> form("#modal form", task: %{title: new_title, description: new_description})
    |> render_submit()

    refute has_element?(view, "#modal")
    assert has_element?(view, "td", new_title)
    assert has_element?(view, "td", new_description)
  end

  test "open edit task modal and update task", %{conn: conn, user: user} do
    task = task_fixture(%{user: user})
    new_title = "Updated Task Title"
    {:ok, view, _html} = live(conn, ~p"/")

    view
    |> element("button[phx-click=open_modal][phx-value-task_id=#{task.id}]")
    |> render_click()

    assert has_element?(view, "#modal")
    assert has_element?(view, "input[name='task[title]'][value='#{task.title}']")

    view
    |> form("#modal form", task: %{title: new_title})
    |> render_submit()

    refute has_element?(view, "#modal")
    assert has_element?(view, "td", new_title)
  end

  test "open delete confirmation modal and delete task", %{conn: conn, user: user} do
    task = task_fixture(%{user: user})
    {:ok, view, _html} = live(conn, ~p"/")

    view
    |> element("button[phx-click=open_delete_modal][phx-value-task_id=#{task.id}]")
    |> render_click()

    assert has_element?(view, "#delete_modal")

    view
    |> element("button[phx-click=delete_task]")
    |> render_click()

    refute has_element?(view, "td", task.title)
    refute has_element?(view, "#delete_modal")
  end

  test "filters tasks by status", %{conn: conn, user: user} do
    _task = task_fixture(%{user: user})
    _task = task_fixture(%{user: user, status: "completed"})

    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "td", "pending")

    view
    |> element("form[phx-change=filter_tasks]")
    |> render_change(%{"status_filter" => "completed"})

    assert has_element?(view, "td", "completed")
    refute has_element?(view, "td", "pending")
  end
end
