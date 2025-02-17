# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TaskManager.Repo.insert!(%TaskManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TaskManager.{Accounts, Repo}
alias TaskManager.Accounts.User
alias TaskManager.Tasks.Task

defmodule SeedHelper do
  def get_or_create_user(attrs) do
    case Repo.get_by(User, email: attrs.email) do
      nil ->
        case Accounts.register_user(attrs) do
          {:ok, user} ->
            user

          {:error, changeset} ->
            IO.puts("Error creating user: #{inspect(changeset)}")
            nil
        end

      user ->
        user
    end
  end

  def create_tasks(users, count) do
    Enum.each(1..count, fn _ ->
      task = %Task{
        title: Faker.Lorem.sentence(3),
        description: Faker.Lorem.paragraph(2),
        status: Enum.random(["pending", "completed"]),
        user_id: Enum.random(users).id
      }

      Repo.insert!(task)
    end)
  end
end

users =
  [
    %{email: "admin1@google.com", password: "password12345"},
    %{email: "admin2@google.com", password: "password12345"},
    %{email: "admin3@google.com", password: "password12345"}
  ]
  |> Enum.map(&SeedHelper.get_or_create_user/1)
  |> Enum.filter(& &1)

if Repo.aggregate(Task, :count, :id) == 0 do
  IO.puts("Seeding tasks...")

  SeedHelper.create_tasks(users, 5)

  IO.puts("Seeding complete!")
else
  IO.puts("Tasks already exist, skipping seeding.")
end
