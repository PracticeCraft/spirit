defmodule Mix.Helpers.GitHub do
  @moduledoc """
  Helper functions for fetching and handling content from the GitHub API.

  Responses from the GitHub API are in the form of "content objects" which are
  JSON objects with the following (relevant) fields:

  - "content": a list of nested content objects (for directories), or a
  base-64-encoded string (for files)

  - "path": file path,e.g., `basic_types/exercises.ex`

  - "url": GitHub API URL for the file or directory
  """

  @doc """
  Fetches the contents of the given `path` using the GitHub API.

  Returns a single content object or a list of them.
  """
  def fetch_gh_contents!("https://api.github.com/repos" <> _ = url) do
    case Req.get!(url) do
      %{status: 200} = response ->
        response.body

      error_response ->
        raise("received non-OK response: #{inspect(error_response, pretty: true)}")
    end
  end

  @doc """
  Fetches `module_list.txt` (which should be at the root of the repo contents)
  and builds the ordered module list from it.
  """
  def fetch_module_list!(repo_contents) do
    module_list_url =
      Enum.find_value(repo_contents, fn
        %{"name" => "module_list.txt", "url" => url} -> url
        _ -> nil
      end)

    if is_nil(module_list_url), do: raise("`module_list.txt` not found in the repo")

    fetch_gh_contents!(module_list_url)
    |> Map.get("content")
    |> Base.decode64!(ignore: :whitespace)
    |> String.split("\n", trim: true)
  end

  @doc """
  Lists the directory names in the given repo contents.

  If the option `:sort_with` is provided with a list, directory names are sorted
  to match the ordering of that list.
  """
  def get_dirs(repo_contents, opts \\ []) do
    dirs =
      repo_contents
      |> Enum.filter(fn %{"type" => type} -> type == "dir" end)
      |> Enum.map(fn %{"name" => name} -> name end)

    case Keyword.get(opts, :sort_with) do
      nil -> dirs
      module_list -> Enum.filter(module_list, fn dir -> dir in dirs end)
    end
  end

  @doc """
  Downloads exercises/tests content given a GitHub content object.

  Fetching is done recursively through directories.
  """
  def download_content_object!(%{"url" => url, "type" => "file"}) do
    %{"content" => content, "path" => path} = fetch_gh_contents!(url)
    exercise_name = path |> String.split("/") |> hd()

    file_path =
      case path do
        ^exercise_name <> "/exercises.ex" ->
          "lib/spirit/#{exercise_name}.ex"

        ^exercise_name <> "/exercises_test.exs" ->
          "test/spirit/#{exercise_name}_test.exs"
      end

    Mix.Generator.create_file(file_path, Base.decode64!(content, ignore: :whitespace))
  end

  def download_content_object!(%{"url" => url, "type" => "dir"}) do
    fetch_gh_contents!(url)
    |> Enum.map(&download_content_object!/1)
  end
end
