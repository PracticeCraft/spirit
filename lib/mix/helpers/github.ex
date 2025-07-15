defmodule Mix.Helpers.GitHub do
  @moduledoc """
  Helper functions for fetching and handling content from the GitHub API.

  Responses from the GitHub API are in the form of "content objects" which are
  JSON objects with the following (relevant) fields:

  - "content": a list of nested content objects (for directories), or a
  base-64-encoded string (for files)
  - "path": file path, e.g., `basic_types/exercises.ex`
  - "url": GitHub API URL for the file or directory
  """

  @debug System.get_env("DEBUG") == "true"

  defp build_url(base_url, path) do
    url = Path.join(base_url, path)
    if @debug, do: url <> "?ref=staging", else: url
  end

  @doc """
  Fetches the contents of the given `path` using the GitHub API.

  Returns a single content object or a list of them.
  """
  def fetch_gh_contents!("https://api.github.com/repos" <> _ = base_url, path) do
    url = build_url(base_url, path)

    case Req.get!(url) do
      %{status: 200} = response ->
        response.body

      error_response ->
        raise("received non-OK response: #{inspect(error_response, pretty: true)}")
    end
  end

  @doc """
  Fetches `modules.json` (which should be at the root of the repo contents) and
  builds the ordered module list from it.

  Returns a flat list of module names in the form of "dir/module", e.g.,
  "basic_types/kpi".
  """
  def fetch_module_list!(base_url) do
    modules_file_name = "modules.json"

    fetch_gh_file!(base_url, modules_file_name)
    |> JSON.decode!()
    |> Map.get("dirs")
    |> Enum.flat_map(fn dir ->
      dir_name = dir["name"]
      dir_modules = dir["modules"]

      Enum.map(dir_modules, fn mod ->
        dir_name <> "/" <> mod
      end)
    end)
  end

  @doc """
  Fetches the file with the given (GitHub API) URL and path and extracts its content.
  """
  def fetch_gh_file!(base_url, path) do
    fetch_gh_contents!(base_url, path)
    |> Map.get("content")
    |> Base.decode64!(ignore: :whitespace)
  end
end
