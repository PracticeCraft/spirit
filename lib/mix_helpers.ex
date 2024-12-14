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
  Lists the directory names in the given repo contents.

  If the repo contents include a `module_list.txt` file, use the content of that
  file to sort the directories in the specified order.
  """
  def get_dirs(repo_contents) do
    dirs =
      repo_contents
      |> Enum.filter(fn %{"type" => type} -> type == "dir" end)
      |> Enum.map(fn %{"name" => name} -> name end)

    case get_module_list_url(repo_contents) do
      nil ->
        dirs

      module_list_url ->
        %{"content" => module_list_content} = Req.get!(module_list_url).body

        module_list_content
        |> Base.decode64!(ignore: :whitespace)
        |> String.split("\n", trim: true)
        |> Enum.filter(fn dir -> dir in dirs end)
    end
  end

  @doc """
  Given the repo contents list, returns the url of the `module_list.txt` file or
  `nil` otherwise.
  """
  def get_module_list_url(repo_contents) do
    Enum.find_value(repo_contents, fn
      %{"name" => "module_list.txt", "url" => url} -> url
      _ -> nil
    end)
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
