defmodule MixHelpers do
  @moduledoc """
  Helpers for the Mix generator task `spirit.gen`
  """

  @doc """
  Fetches the contents of the given `path` using the GitHub API.
  """
  def fetch_gh_contents!("https://api.github.com/repos" <> _ = path) do
    case Req.get!(path) do
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

  If the option `:sort_with` is provided with a list, directory names are
  reordered as per that list.
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
  Downloads exercises/tests content given a GitHub contents "object".

  Fetching is done recursively through directories.
  """
  def download_content_object(%{"url" => url, "type" => "file"}) do
    %{"content" => content, "path" => path} = Req.get!(url).body
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

  def download_content_object(%{"url" => url, "type" => "dir"}) do
    fetch_gh_contents!(url)
    |> Enum.map(&download_content_object/1)
  end
end
