defmodule Mix.Tasks.Spirit.Gen do
  use Mix.Task

  @base_url "https://raw.githubusercontent.com/waseem-medhat/spirit-exercises/main"

  @chapters %{
    "Basic Types" => "basic_types"
  }

  def download_file!(chapter_slug, file_type) do
    {file_url, download_path} =
      case file_type do
        :exercises ->
          url = "#{@base_url}/#{chapter_slug}/exercises.ex"
          path = "lib/spirit/#{chapter_slug}.ex"
          {url, path}

        :tests ->
          url = "#{@base_url}/#{chapter_slug}/tests.ex"
          path = "test/spirit/#{chapter_slug}.exs"
          {url, path}
      end

    IO.puts("Downloading file #{file_url}")

    case HTTPoison.get!(file_url) do
      %HTTPoison.Response{status_code: 200, body: file} ->
        File.write!(download_path, file)
        IO.puts("Saved at #{download_path}\n")

      %HTTPoison.Response{status_code: code} ->
        raise("Error downloading file, status code: #{code}")
    end
  end

  def run([chapter_name]) do
    HTTPoison.start()
    chapter_slug = @chapters[chapter_name]

    download_file!(chapter_slug, :exercises)
    download_file!(chapter_slug, :tests)

    IO.puts("'#{chapter_name}' exercises successfully set up. Happy coding!")
  end
end
