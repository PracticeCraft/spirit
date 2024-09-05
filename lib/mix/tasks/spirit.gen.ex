defmodule Mix.Tasks.Spirit.Gen do
  use Mix.Task

  @base_url "https://raw.githubusercontent.com/waseem-medhat/spirit-exercise-bank/main"

  @chapters %{
    "Basic Types" => "basic_types"
  }

  def get_files(chapter_name) do
    chapter_slug = @chapters[chapter_name]
    exercises_url = "#{@base_url}/#{chapter_slug}/exercises.ex"
    tests_url = "#{@base_url}/#{chapter_slug}/tests.ex"

    HTTPoison.start()
    %{body: exercises_file} = HTTPoison.get!(exercises_url)
    %{body: tests_file} = HTTPoison.get!(tests_url)

    {exercises_file, tests_file}
  end

  def run([chapter_name]) do
    {ex, ts} = get_files(chapter_name)
    IO.puts(ex)
    IO.puts(ts)
  end
end
