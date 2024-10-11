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

  def fetch_content_object(%{"url" => url, "type" => "file"}) do
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

  def fetch_content_object(%{"url" => url, "type" => "dir"}) do
    MixHelpers.fetch_dir_contents(url)
    |> Enum.map(&MixHelpers.fetch_content_object/1)
  end
end
