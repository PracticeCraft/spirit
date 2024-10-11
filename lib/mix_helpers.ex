defmodule MixHelpers do
  def fetch_repo_contents(path) do
    Req.get!(path).body
  end

  def get_dirs(repo_contents) do
    Enum.filter(repo_contents, fn %{"type" => type} -> type == "dir" end)
  end

  def fetch_dir_contents(path) do
    Req.get!(path).body
  end

  def fetch_file(%{"url" => url} = file_info) do
    Req.get!(url).body
    |> IO.inspect()

    IO.inspect(file_info)
  end

  # def write_file()
end
