# Elixir LiveView Task Application

## Overview

This is a simple real-time collaborative task management application built with Phoenix LiveView. It allows users to create, update, delete, and track tasks in real time. The app ensures that the task list remains synchronized across all users without requiring page reloads, leveraging **Phoenix LiveView's** real-time capabilities.

The application follows a mobile-first design approach and uses **Tailwind CSS** for styling. It also features authentication with Phoenix built-in auth, dynamic task filtering

The solution includes a **Dockerized PostgreSQL** database for persistent storage of users, tasks and all functionality runs locally with `mix phx.server`.

## Features

- **User Authentication** – _Users can sign up with an email and password using Phoenix Auth._
- **Real-time Updates** – _Task list updates instantly when tasks are created, updated, or deleted._
- **Task Management** – _Create, edit, delete, and mark tasks as pending or completed._
- **Task Filtering** – _Filter tasks by status ("All", "Pending", "Completed") without page reloads._
- **Mobile-Friendly UI** – _Built with Tailwind CSS for a responsive experience._
- **Persistent Storage** – _Runs PostgreSQL in a Docker container and uses Ecto for data management._
- **LiveView Hook** – _Enhances interactivity with client-side hook._
- **Real-time Messaging** – Uses **Phoenix.PubSub** to broadcast task updates, creates, deletion to all connected users.
- **User Presence Tracking** – Shows the number of active users in real-time using **Phoenix.Presence**.

## Prerequisites

- **Docker & Docker Compose**: Ensure Docker is installed to run the database container.
- **Elixir and Phoenix**: The app was developed using Elixir and the Phoenix framework.

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/OlegGorod/task_manager.git
cd task_manager
```

### 2. Database Setup with Docker

This project includes a docker-compose.yml file to simplify database setup.

Start the Database:

```bash
docker-compose up -d
```

### 3. Install Dependencies and set up the application with db setup

Install Elixir and JavaScript dependencies:

```bash
mix setup
```

### 4. Run the Server

Start the Phoenix server (from the root directory):

```bash
mix phx.server
```

### 5. Default Logins

To access the app, use one of the following accounts:

- **Email:** `admin1@google.com`, **Password**: `password12345`
- **Email:** `admin2@google.com`, **Password**: `password12345`
- **Email:** `admin3@google.com`, **Password**: `password12345`

All default accounts share the same password set in your seed configuration.

The application will be available at [http://localhost:4000](http://localhost:4000).

## Key Design and Implementation Details

### Responsive Design (Mobile-First)

- **Tailwind CSS**: A mobile-first approach with Tailwind CSS ensures that the app is responsive and adapts well to different screen sizes.

### Phoenix PubSub for Real-Time Updates

- **Broadcasting Task Updates**: Phoenix PubSub is used to broadcast new tasks in real-time. When a user create a task, a task is sent to all connected clients, updating tasks instantly.

### Dockerization

- **Persistent Database Setup**: The PostgreSQL database runs in a Docker container, isolated from your local environment for ease of use.
- **Automated Database Initialization**: `docker-compose` along with `mix ecto` commands handle migrations and seed data setup, streamlining project setup.

## Project Structure

- **Phoenix Contexts** organize the code for tasks, users into manageable, modular components.
- **Ecto Schemas** handle data persistence for users, tasks with validations to enforce business rules.

## Testing

Core functionality, such as task creation, updating, deleting, user creation are covered by unit tests. To run tests:

```bash
mix test
```

## Design Decisions & Trade-Offs

- **LiveView Over Traditional SPA**: LiveView was chosen for real-time updates without requiring a full SPA framework like React or Vue. This reduces complexity and keeps the application server-rendered.
- **Filtering with Ecto**: Filtering are implemented using efficient **Ecto queries**, ensuring that the database does the heavy lifting and reduces the memory footprint on the server side. This makes fetching tasks and results faster, even as the data grows.

## Dependencies

The project uses the following dependencies:

- **Elixir**: "~> 1.14.0"
- **Phoenix**: "~> 1.7.11"
- **Phoenix Live View**: "~> 0.20"

## License

This project is licensed under the MIT License.
