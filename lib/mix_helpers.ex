defmodule MixHelpers do
  @moduledoc """
  Helpers for the Mix generator task `spirit.gen`
  """

  @doc """
  Fetches the contents of the given `path` using the GitHub API.
  """
  def fetch_gh_contents!("https://api.github.com/repos" <> _ = path) do
    Req.get!(path).body
  end

  @doc """
  Filters the contents of a repo for directories only.
  """
  def get_dirs(repo_contents) do
    Enum.filter(repo_contents, fn %{"type" => type} -> type == "dir" end)
  end

  @doc """
  Downloads exercises/tests content given a GitHub contents "object".

  Fetching is done recursively through directories.
  """
  def download_content_object(%{"url" => url, "type" => "file"}) do
    %{"content" => content, "path" => path} = Req.get!(url).body

    path_prefix =
      case Path.extname(path) do
        ".ex" ->
          "lib/exercises"

        ".exs" ->
          "test/exercises"
      end

    full_path = Path.join([path_prefix, path])

    Mix.Generator.create_file(full_path, Base.decode64!(content, ignore: :whitespace))
  end

  def download_content_object(%{"url" => url, "type" => "dir"}) do
    fetch_gh_contents!(url)
    |> Enum.map(&download_content_object/1)
  end
end
