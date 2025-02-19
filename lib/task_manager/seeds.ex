defmodule TaskManager.Seeds do
  alias TaskManager.{Accounts, Repo}
  alias TaskManager.Accounts.User
  alias TaskManager.Tasks.Task

  defmodule SeedHelper do
    def get_or_create_user(attrs) do
      with nil <- Repo.get_by(User, email: attrs.email),
           {:ok, user} <- Accounts.register_user(attrs) do
        user
      else
        user when is_map(user) ->
          user

        {:error, changeset} ->
          IO.puts("Error creating user: #{inspect(changeset)}")
          nil
      end
    end

    def create_tasks(users, count) do
      Enum.each(1..count, fn _ ->
        task = %Task{
          title: Faker.Lorem.sentence(1),
          description: Faker.Lorem.sentence(2),
          status: Enum.random(["pending", "completed"]),
          user_id: Enum.random(users).id
        }

        Repo.insert!(task)
      end)
    end
  end

  def run do
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
  end
end
