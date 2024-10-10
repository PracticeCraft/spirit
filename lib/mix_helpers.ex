defmodule MixHelpers do
  @base_url "https://api.github.com/repos/PracticeCraft/spirit-exercises/contents/"

  def fetch_repo_contents(path \\ @base_url) do
    Req.get!(path).body
  end

  def get_dirs(repo_contents) do
    Enum.filter(repo_contents, fn %{"type" => type} -> type == "dir" end)
  end

  def fetch_dir_contents(path) do
    Req.get!(path).body
  end

  # def write_file()

  def testing() do
    %{"url" => url} =
      fetch_repo_contents()
      |> get_dirs()
      |> Enum.at(0)

    fetch_dir_contents(url)
    |> Enum.map(fn %{"download_url" => download_url} ->
      Req.get!(download_url).body
      |> IO.inspect()
    end)
  end
end
