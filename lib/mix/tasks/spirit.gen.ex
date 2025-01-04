defmodule Mix.Tasks.Spirit.Gen do
  use Mix.Task

  @base_url "https://api.github.com/repos/PracticeCraft/spirit-exercises/contents/"

  def run(args) do
    {opts, remaining_args, _} = OptionParser.parse(args, switches: [path: :string])
    path = opts[:path] || @base_url

    handle_args(path, remaining_args)
  end

  defp handle_args(path, args) do
    startup_sequence()
    repo_contents = Mix.Helpers.GitHub.fetch_gh_contents!(path)
    module_list = Mix.Helpers.GitHub.fetch_module_list!(repo_contents)
    available_modules = Mix.Helpers.GitHub.get_dirs(repo_contents, sort_with: module_list)

    fetch_result =
      case args do
        [] -> fetch_next_module(available_modules, repo_contents)
        [arg] -> fetch_module(arg, repo_contents)
        _ -> {:error, :invalid_cmd}
      end

    Mix.Helpers.IO.print_result_message(fetch_result, available_modules)
  end

  defp fetch_next_module(available_modules, repo_contents) do
    case find_next_module(available_modules) do
      :complete ->
        {:ok, :complete}

      next_module ->
        case Mix.Helpers.IO.confirm_download?(next_module) do
          true -> fetch_module(next_module, repo_contents)
          false -> {:error, :aborted}
        end
    end
  end

  defp fetch_module(module_name, repo_contents) do
    module_dir =
      Enum.find(repo_contents, :not_found, fn %{"name" => name, "type" => type} ->
        type == "dir" and name == module_name
      end)

    case module_dir do
      :not_found ->
        {:error, :enoent}

      dir ->
        Mix.Helpers.GitHub.download_content_object!(dir)
        {:ok, :fetched}
    end
  end

  defp find_next_module(available_modules) do
    saved_modules =
      case File.ls("lib/spirit") do
        {:error, :enoent} -> []
        {:ok, file_list} -> Enum.map(file_list, fn file -> String.trim_trailing(file, ".ex") end)
      end

    Enum.find(available_modules, :complete, fn module -> module not in saved_modules end)
  end

  defp startup_sequence() do
    {:ok, _} = Application.ensure_all_started(:req)
  end
end
