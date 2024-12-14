defmodule Mix.Tasks.Spirit.Gen do
  use Mix.Task

  @base_url "https://api.github.com/repos/PracticeCraft/spirit-exercises/contents/"

  def run(args) do
    {opts, remaining_args, _} =
      OptionParser.parse(args,
        switches: [
          path: :string
        ]
      )

    path = opts[:path] || @base_url

    handle_args(path, remaining_args)
  end

  defp handle_args(path, args) do
    startup_sequence()
    repo_contents = MixHelpers.fetch_gh_contents!(path)

    case args do
      [] -> get_module(repo_contents)
      [arg] -> get_module(repo_contents, arg)
    end
  end

  defp get_module(repo_contents) do
    module_list = MixHelpers.get_dirs(repo_contents)

    case check_next_module(module_list) do
      {:ok, :complete} ->
        Mix.Shell.IO.info("Nothing to generate. You have all available exercises! 🎉")

      {:ok, next_module} ->
        get_module(repo_contents, next_module)

      {:error, :abort} ->
        Mix.Shell.IO.info("Aborted")
    end
  end

  defp get_module(repo_contents, module_name) do
    repo_contents
    |> Enum.find(:not_found, fn %{"name" => name, "type" => type} ->
      type == "dir" and name == module_name
    end)
    |> case do
      :not_found -> print_options(repo_contents)
      dir -> download_contents(dir)
    end
  end

  defp download_contents(%{"url" => url}) do
    MixHelpers.fetch_gh_contents!(url)
    |> Enum.map(&MixHelpers.download_content_object/1)
  end

  defp startup_sequence() do
    {:ok, _} = Application.ensure_all_started(:req)
  end

  defp print_options(repo_contents) do
    info_block_output()

    Mix.Shell.IO.info("Available options are:\n")

    repo_contents
    |> MixHelpers.get_dirs()
    |> Enum.map(&Mix.Shell.IO.info/1)

    Mix.Shell.IO.info("")
  end

  defp info_block_output() do
    Mix.Shell.IO.error("** Error: invalid command")

    Mix.Shell.IO.info("""

    Spirit Gen needs to run with one string argument for the exercise to download
    Each string argument should be snake case
    Either no arg was provided or there was no match

    Example: basic_types
    """)
  end

  defp check_next_module(module_list) do
    saved_modules =
      case File.ls("lib/spirit") do
        {:error, :enoent} ->
          []

        {:ok, file_list} ->
          Enum.map(file_list, fn file_name -> String.trim_trailing(file_name, ".ex") end)
      end

    next_module = Enum.find(module_list, fn module -> module not in saved_modules end)

    case next_module do
      nil -> {:ok, :complete}
      module -> prompt_next_module(module)
    end
  end

  defp prompt_next_module(next_module) do
    Mix.Shell.IO.info(
      "Based on what you have saved in your project, " <>
        "the next module to fetch is:\n\n#{next_module}\n"
    )

    Mix.Shell.IO.yes?("Proceed to generate exercises for this module?")
    |> case do
      true -> {:ok, next_module}
      false -> {:error, :abort}
    end
  end
end
