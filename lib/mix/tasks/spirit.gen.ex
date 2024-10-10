defmodule Mix.Tasks.Spirit.Gen do
  use Mix.Task

  @base_url "https://api.github.com/repos/PracticeCraft/spirit-exercises/contents/"

  @chapters %{
    "Basic Types" => "basic_types"
  }

  # def download_file!(chapter_slug, file_type) do
  #   {file_url, download_path} =
  #     case file_type do
  #       :exercises ->
  #         url = "#{@base_url}/#{chapter_slug}/exercises.ex"
  #         path = "lib/spirit/#{chapter_slug}.ex"
  #         {url, path}

  #       :tests ->
  #         url = "#{@base_url}/#{chapter_slug}/tests.ex"
  #         path = "test/spirit/#{chapter_slug}.exs"
  #         {url, path}
  #     end

  #   IO.puts("Downloading file #{file_url}")

  #   case HTTPoison.get!(file_url) do
  #     %HTTPoison.Response{status_code: 200, body: file} ->
  #       File.write!(download_path, file)
  #       IO.puts("Saved at #{download_path}\n")

  #     %HTTPoison.Response{status_code: code} ->
  #       raise("Error downloading file, status code: #{code}")
  #   end
  # end

  def run([chapter_name]) do
    startup_sequence()
    # HTTPoison.start()
    # chapter_slug = @chapters[chapter_name]

    # download_file!(chapter_slug, :exercises)
    # download_file!(chapter_slug, :tests)

    # IO.puts("'#{chapter_name}' exercises successfully set up. Happy coding!")

    IO.puts("Still got work to do, but the mix task works")
  end

  def run([]) do
    startup_sequence()
    Mix.Shell.IO.info("#{TerminalHelpers.style("*** Attention", [:bold, :fg_cyan])}")

    Mix.Shell.IO.info(
      "Spirit Gen needs to run with one string arguement for the exercise to download"
    )

    Mix.Shell.IO.info("Each string argument should be wrapped in quotes, such as \"Basic Types\"")
    Mix.Shell.IO.info("")
    Mix.Shell.IO.info("Example: \"Basic Types\"")

    Mix.Shell.IO.info("")

    Mix.Shell.IO.info("Available options are:")

    Mix.Shell.IO.info("")

    MixHelpers.fetch_repo_contents()
    |> MixHelpers.get_dirs()
    |> Enum.map(fn %{"name" => name} ->
      String.split(name, "_")
      |> Enum.map(&String.capitalize/1)
      |> Enum.join(" ")
      |> (&"\"#{&1}\"").()
    end)
    |> Enum.map(&Mix.Shell.IO.info/1)

    Mix.Shell.IO.info("")
  end

  defp startup_sequence() do
    {:ok, _} = Application.ensure_all_started(:req)
  end
end
