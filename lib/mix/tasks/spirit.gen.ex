defmodule Mix.Tasks.Spirit.Gen do
  use Mix.Task

  @default_base_url "https://api.github.com/repos/PracticeCraft/spirit-exercises/contents/"

  def run(args) do
    {opts, remaining_args, _} = OptionParser.parse(args, switches: [path: :string])
    base_url = opts[:path] || @default_base_url
    handle_args(base_url, remaining_args)
  end

  defp handle_args(base_url, args) do
    startup_sequence()
    module_list = Mix.Helpers.GitHub.fetch_module_list!(base_url)

    fetch_result =
      case args do
        [] -> fetch_next_module(module_list, base_url)
        [arg] -> fetch_module(arg, module_list, base_url)
        _ -> {:error, :invalid_cmd}
      end

    Mix.Helpers.IO.print_result_message(fetch_result, module_list)
  end

  defp fetch_next_module(module_list, base_url) do
    case find_next_module(module_list) do
      :complete ->
        {:ok, :complete}

      next_module ->
        case Mix.Helpers.IO.confirm_download?(next_module) do
          true -> fetch_module(next_module, module_list, base_url)
          false -> {:error, :aborted}
        end
    end
  end

  defp fetch_module(module_name, module_list, base_url) do
    if module_name not in module_list do
      {:error, :enoent}
    else
      exercise_path = Path.join(module_name, "exercises.ex")
      exercise_content = Mix.Helpers.GitHub.fetch_gh_file!(base_url, exercise_path)
      Mix.Generator.create_file("lib/spirit/#{module_name}.ex", exercise_content)

      tests_path = Path.join(module_name, "exercises_test.exs")
      tests_content = Mix.Helpers.GitHub.fetch_gh_file!(base_url, tests_path)
      Mix.Generator.create_file("test/spirit/#{module_name}_test.exs", tests_content)

      {:ok, :fetched}
    end
  end

  defp find_next_module(module_list) do
    base_dir = "lib/spirit"
    File.mkdir_p!(base_dir)

    saved_modules =
      Enum.flat_map(File.ls!(base_dir), fn dir ->
        subdirs = Path.join(base_dir, dir) |> File.ls!()

        Enum.map(subdirs, fn file_name ->
          module_name = String.trim_trailing(file_name, ".ex")
          dir <> "/" <> module_name
        end)
      end)

    Enum.find(module_list, :complete, fn module -> module not in saved_modules end)
  end

  defp startup_sequence() do
    {:ok, _} = Application.ensure_all_started(:req)
  end
end
