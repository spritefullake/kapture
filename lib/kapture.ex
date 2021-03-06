defmodule Kapture do
  @moduledoc """
  Documentation for `Kapture`.
  """
  def compose_url(url, num) do
    "#{url}seg-#{num}-v1-a1.ts"
  end
  @doc"""
  capture a Kaltura video on brightspace.
  The URL is of this form:
  https://cfvod.kaltura.com/{there will be some stuff here}/a.mp4/seg-68-v1-a1.ts
  and the seg-{number}-v1-al.ts part can be modified!
  """
  #https://cfvod.kaltura.com/hls/p/983291/sp/98329100/serveFlavor/entryId/1_t5833ocv/v/1/ev/6/flavorId/1_gx3dh23f/name/a.mp4/seg-68-v1-a1.ts

  def capture(url, file, segment \\ 1) do
    case HTTPoison.get(compose_url(url, segment)) do
      {:error, err} -> err
      {:ok, res} when res.status_code == 404 -> ""
      {:ok, res} ->
        IO.binwrite(file, res.body)
        capture(url, file, segment + 1)
    end
  end

  def save_video(url, name \\ "final.mp4") do
    {:ok, file} = File.open(name, [:binary, :append])
    capture(url, file, 1)
    File.close(file)
  end

  def hello do
    :world
    #Kapture.save_video("https://cfvod.kaltura.com/hls/p/983291/sp/98329100/serveFlavor/entryId/1_9sddka0u/v/1/ev/6/flavorId/1_6ytzjj2f/name/a.mp4/","18-prt3.mp4")
    #Kapture.save_video("https://cfvod.kaltura.com/hls/p/983291/sp/98329100/serveFlavor/entryId/1_mc9r6lof/v/1/ev/6/flavorId/1_lvji7yh9/name/a.mp4/","18-prt2.mp4")
  end
end
