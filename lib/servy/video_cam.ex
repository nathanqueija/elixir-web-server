defmodule Servy.VideoCam do

  @doc """
  Simulates sending a request to an external API
  to get a snapshot image from a video camera
  """

  def get_snapshot(camera_name) do

    :timer.sleep(1000)

    "#{camera_name}-snapshot.jpg"
    end

end
