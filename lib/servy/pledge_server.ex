defmodule Servy.PledgeServer do

  @process_name :pledge_server
  def start(initial_state \\ []) do
    IO.puts "Starting the Pledge server"
    pid = spawn(fn -> listen_loop(initial_state) end)
    # pid = spawn(__MODULE__, :listen_loop, initial_state)
    Process.register(pid, @process_name)
    pid
  end

# Client Interface
  def create_pledge(name, amount) do
    send @process_name, {self(), :create_pledge, name, amount}
    receive do {:response, status} -> status end
  end

  def recent_pledges do
    send @process_name, {self(), :recent_pledges}

    receive do {:response, pledges} -> pledges end
  end

  def total_pledged do
    send @process_name, {self(), :total_pledged}

    receive do {:response, total} -> total end
  end

  # Server
  def listen_loop(state) do
    # receive wait for a messagea arrives in this process
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(state, 2)
        new_state = [{name, amount} | most_recent_pledges]
        send sender, {:response, id}
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send sender, {:response, state}
        listen_loop(state)

      {sender, :total_pledged} ->
        total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
        send sender, {:response, total}
        listen_loop(state)

      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state)
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    # Code goes here to send pledge to external service

    {:ok, "pledge-#{:rand.uniform(1000)}"}

  end
end
