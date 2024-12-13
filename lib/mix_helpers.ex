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

  @doc """
  Lists all module names in the same order as the official guide.
  """
  def list_all_modules() do
    [
      "basic_types",
      "lists_and_tuples",
      "pattern_matching",
      "case_cond_and_if",
      "anonymous_functions",
      "binaries_strings_and_charlists"
    ]
  end
end
