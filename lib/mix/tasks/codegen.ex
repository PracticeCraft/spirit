defmodule Mix.Tasks.Codegen do
  use Mix.Task

  def run(_) do
    File.cwd()
    |> IO.inspect()
  end
end
