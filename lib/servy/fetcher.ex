defmodule Servy.Fetcher do
  def async(fun) do
    parent_pid = self()
    spawn(fn -> send(parent_pid, {self(), :result,fun.()}) end)
  end

  def get_result(pid) do
    receive do
      {^pid, :result, value} -> value
    after 2000 ->
      raise "Timed out!"
    end
  end
end
